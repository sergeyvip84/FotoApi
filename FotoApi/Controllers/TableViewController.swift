//
//  TableViewController.swift
//  FotoApi
//
//  Created by Serhii Palamarchuk on 30.05.2022.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    
    let realm = try! Realm()
    var realmArray: Results<TaskList>!
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.placeholder = "Enter foto's name you need"
            textField.delegate = self
            textField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var loader: UIActivityIndicatorView! {
        didSet {
            loader.isHidden = true
            loader.color = .blue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .systemGray5
        
        realmArray = realm.objects(TaskList.self)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
    
 
        let spending = realmArray[indexPath.row]
        cell.textLabel?.text = spending.nameTask
        cell.imageView?.image = UIImage(data: spending.imageTask)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let spending = realmArray[indexPath.row]
            try! realm.write {
                realm.delete(spending)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! DetailVC
                
                let spending = realmArray[indexPath.row]
                detailVC.imageTitle = spending.nameTask
                detailVC.imageSegue = spending.imageTask
            }
        }
    }
    
    func searchImage(text: String) {
        
        showLoader(show: true)
        
        let base = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="
        let format = "&format=json&nojsoncallback=1"
        let farmattedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let textToSearch = "&text=\(farmattedText)"
        let sort = "&sort=relevance"
        
        let searchUrl = base + key + textToSearch + sort + format
        
        let url = URL(string: searchUrl)!
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let jsonData = data else {
                self.showLoader(show: false)
                self.showError(text:"Error, json is empty")
                return
            }
            guard let jsonAny = try? JSONSerialization.jsonObject(with: jsonData, options: []) else{
                self.showLoader(show: false)
                return
            }
            guard let json = jsonAny as? [String: Any] else {
                self.showLoader(show: false)
                return
            }
            
            guard let photos = json["photos"] as? [String: Any] else {
                self.showLoader(show: false)
                return
            }
            
            guard let photosArray = photos["photo"] as? [Any] else {
                self.showLoader(show: false)
                return
            }
            
            guard photosArray.count > 0 else {
                self.showLoader(show: false)
                self.showError(text: "Photos is empty")
                return
            }
            
            guard let randomPhoto = photosArray[Int.random(in: 0...photosArray.count)] as? [String: Any] else {
                self.showLoader(show: false)
                return
            }
            
            let farm = randomPhoto["farm"] as! Int
            let id = randomPhoto["id"] as! String;
            let secret = randomPhoto["secret"] as! String;
            let server = randomPhoto["server"] as! String;
            
            let pictureUrl = self.convert(farm: farm, server: server, id: id, secret: secret)
            
            URLSession.shared.dataTask(with: pictureUrl!, completionHandler: { (data, _, _) in
                DispatchQueue.main.async { [self] in
                    
                    let value = TaskList(value: [data!, text])
                    try! realm.write {
                        realm.add(value)
                    }
                    tableView.reloadData()
                }
                self.showLoader(show: false)
            }).resume()
        }.resume()
    }
    
    func convert(farm: Int, server: String, id:String, secret: String) -> URL? {
        return URL(string:"https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_c.jpg")
    }
    
    func showError(text: String) {
        let alert = UIAlertController(title: "Bad request", message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    func showLoader(show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.loader.startAnimating()
                self.loader.isHidden = false
            }
            else {
                self.loader.stopAnimating()
                self.loader.isHidden = true
            }
        }
    }
}

extension TableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchImage(text: textField.text!)
        return true
    }
}
