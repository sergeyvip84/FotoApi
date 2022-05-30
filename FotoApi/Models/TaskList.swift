//
//  TaskList.swift
//  FotoApi
//
//  Created by Serhii Palamarchuk on 30.05.2022.
//

import RealmSwift

class TaskList: Object {
    @objc dynamic var imageTask = Data()
    @objc dynamic var nameTask = ""
}

