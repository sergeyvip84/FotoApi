//
//  TaskList.swift
//  FotoApi
//
//  Created by Serhii Palamarchuk on 30.05.2022.
//

import RealmSwift
import Foundation

class TaskListNew: Object {
    @objc dynamic var imageTask = Data()
    @objc dynamic var nameTask = ""
    @objc dynamic var urlTask = ""
}

