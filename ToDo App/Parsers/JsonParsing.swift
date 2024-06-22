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
    
    /// The method detects the given type and the converts it to the Data format.
    private static func convertToData(json: Any) -> Data? {
        if let json = json as? String {
            return Data(json.utf8)
        }
        return json as? Data
    }
    
    /// Generates a new task from the dictionary of values.
    init? (dict: [String: Any]) {
        let getValue = { (identifier: TodoItemStoredFields) in dict[identifier.rawValue]
        }
        
        id = (getValue(.id) as? String) ?? UUID().uuidString
        guard let text = getValue(.text) as? String else {
            return nil
        }
        self.text = text
        priority = PriorityChoices.getPriorityFrom(string: getValue(.priority) as? String ?? "")!
        deadline = Date.getDate(fromStringLocale: getValue(.deadline) as? String)
        guard let completed = Bool.getBool(fromString: getValue(.completed) as? String) else {
            return nil
        }
        self.completed = completed
        creationDate = Date.getDate(fromStringLocale: getValue(.creationDate) as? String) ?? Date.now
        lastChangeDate = Date.getDate(fromStringLocale: getValue(.lastChangedDate) as? String)
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard let jsonData = convertToData(json: json),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            return nil
        }
        return TodoItem(dict: jsonObject)
    }
    
    var dict: [String: Any] {
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
        return object
    }
    
    var json: Any {
        return (try? JSONSerialization.data(withJSONObject: dict)) ?? Data()
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
