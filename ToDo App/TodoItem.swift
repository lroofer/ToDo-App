//
//  TodoItem.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import Foundation

struct TodoItem {
    enum PriorityChoices {
        case low, ordinary, high
    }
    let id: UUID
    let text: String
    let priority: PriorityChoices
    let deadline: Date?
    let completed: Bool
    let creationDate: Date
    let lastChangeDate: Date?
}

extension TodoItem {
    enum TodoItemStoredFields: String {
        case id = "id"
        case text = "text"
        case priority = "priority"
        case deadline = "deadline"
        case completed = "completed"
    }
    
    static func convertToData(json: Any) -> Data? {
        if let json = json as? String {
            return Data(json.utf8)
        }
        return json as? Data
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard let jsonData = convertToData(json: json), 
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            return nil
        }
        let getValue = { (identifier: TodoItemStoredFields) in jsonObject[identifier.rawValue]
        }
        
        let id = (getValue(.id) as? UUID) ?? UUID()
        guard let text = getValue(.text) as? String else {
            return nil
        }
        let priority = (getValue(.priority) as? PriorityChoices) ?? .ordinary
        let deadline = getValue(.deadline) as? Date
        guard let completed = getValue(.completed) as? Bool else {
            return nil
        }
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, completed: completed, creationDate: Date.now, lastChangeDate: nil)
    }
    
    var json: Any {
        var object = [String: Any]()
        let setValue = {(identifier: TodoItemStoredFields, value: Any) in object[identifier.rawValue] = value}
        setValue(.id, id)
        setValue(.text, text)
        if priority != .ordinary {
            setValue(.priority, priority)
        }
        if deadline != nil {
            setValue(.deadline, deadline!)
        }
        setValue(.completed, completed)
        return (try? JSONSerialization.data(withJSONObject: object)) ?? Data()
    }
}
