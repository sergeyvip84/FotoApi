//
//  DetailVC.swift
//  FotoApi
//
//  Created by Serhii Palamarchuk on 30.05.2022.
//

import UIKit



class DetailVC: UIViewController {

    var urlString = ""
    var imageTitle = ""

    var dataProvider: DataProvider!

    let image : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //      view.frame = CGRect(x: 0, y: 0, width: 200, height: 400)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.layer.shadowOffset = CGSize(width: 0, height: 15)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 20
        return view
    } ()

    let label : UILabel = {
        let text = UILabel ()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .darkText
        return text
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: urlString)!
        dataProvider.downloadImage(url: url) { image in
            self.image.image = image
        }

        view.addSubview(image)
        view.addSubview(label)

        createImageViewConstraint()
        createLabelViewConstraint()

        label.text = imageTitle
    }

    deinit {
        print("controller dismissed")
    }

    func createLabelViewConstraint() {

        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true

    }

    func createImageViewConstraint() {

        image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        image.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        image.heightAnchor.constraint(equalToConstant: 400).isActive = true
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true

        //        NSLayoutConstraint(item: image,
        //                           attribute: .leading,
        //                           relatedBy: .equal,
        //                           toItem: view,
        //                           attribute: .leadingMargin,
        //                           multiplier: 1,
        //                           constant: 0).isActive = true
        //        NSLayoutConstraint(item: image,
        //                           attribute: .trailing,
        //                           relatedBy: .equal,
        //                           toItem: view,
        //                           attribute: .trailingMargin,
        //                           multiplier: 1,
        //                           constant: 0).isActive = true
        //        NSLayoutConstraint(item: image,
        //                           attribute: .top,
        //                           relatedBy: .equal,
        //                           toItem: view,
        //                           attribute: .topMargin,
        //                           multiplier: 1,
        //                           constant: 50).isActive = true
        //        NSLayoutConstraint(item: image,
        //                           attribute: .height,
        //                           relatedBy: .equal,
        //                           toItem: image,
        //                           attribute: .width,
        //                           multiplier: 1,
        //                           constant: 0).isActive = true
    }
}
