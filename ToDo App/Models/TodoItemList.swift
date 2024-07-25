//
//  TodoItemList.swift
//  ToDo App
//
//  Created by Егор Колобаев on 25.07.2024.
//

import Foundation

struct TodoItemList: JSONParsable {
    init?(from data: Any) {
        guard let list = data as? [Any] else {
            return nil
        }
        var ans = [TodoItem]()
        for taskData in list {
            if let parsedTask = taskData as? [String: Any], let task = TodoItem(from: parsedTask) {
                ans.append(task)
            }
        }
        tasks = ans
    }
    
    let tasks: [TodoItem]
    var json: Any {
        var object = [Any]()
        for task in tasks {
            object.append(task.json)
        }
        return object
    }
}
