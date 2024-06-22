//
//  JsonParsing.swift
//  ToDo App
//
//  Created by Егор Колобаев on 19.06.2024.
//

import Foundation

extension TodoItem {
    enum TodoItemStoredFields: String {
        case id = "id"
        case text = "text"
        case priority = "priority"
        case deadline = "deadline"
        case completed = "completed"
        case creationDate = "creationDate"
        case lastChangedDate = "lastChangedDate"
    }
    
    private static func convertToData(json: Any) -> Data? {
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
        
        let id = (getValue(.id) as? String) ?? UUID().uuidString
        guard let text = getValue(.text) as? String else {
            return nil
        }
        let priority = PriorityChoices.getPriorityFrom(string: getValue(.priority) as? String ?? "")!
        let deadline = Date.getDate(fromStringLocale: getValue(.deadline) as? String)
        guard let completed = Bool.getBool(fromString: getValue(.completed) as? String) else {
            return nil
        }
        let creationDate = Date.getDate(fromStringLocale: getValue(.creationDate) as? String) ?? Date.now
        let lastChangeDate = Date.getDate(fromStringLocale: getValue(.lastChangedDate) as? String)
        
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, completed: completed, creationDate: creationDate, lastChangeDate: lastChangeDate)
    }
    
    var json: Any {
        var object = [String: Any]()
        let setValue = {(identifier: TodoItemStoredFields, value: Any) in object[identifier.rawValue] = value}
        setValue(.id, id)
        setValue(.text, text)
        if priority != .ordinary {
            setValue(.priority, priority.rawValue)
        }
        if deadline != nil {
            setValue(.deadline, deadline!.ISO8601Format())
        }
        setValue(.completed, completed ? "true" : "false")
        setValue(.creationDate, creationDate.ISO8601Format())
        if lastChangeDate != nil {
            setValue(.lastChangedDate, lastChangeDate!.ISO8601Format())
        }
        return (try? JSONSerialization.data(withJSONObject: object)) ?? Data()
    }
}

extension Date {
    static func getDate(fromStringLocale date: String?) -> Date? {
        if date == nil {
            return nil
        }
        return ISO8601DateFormatter().date(from: date!)
    }
}

extension Bool {
    static func getBool(fromString string: String?) -> Bool? {
        switch(string) {
        case "true":
            return true
        case "false":
            return false
        default:
            return nil
        }
    }
}
