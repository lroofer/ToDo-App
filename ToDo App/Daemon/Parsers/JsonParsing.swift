//
//  JsonParsing.swift
//  ToDo App
//
//  Created by Егор Колобаев on 19.06.2024.
//

import Foundation
import SwiftUI

extension TodoItem {
    enum TodoItemStoredFields: String {
        case id
        case text
        case importance
        case deadline
        case done
        case color
        case createdTime = "created_at"
        case changedTime = "changed_at"
    }
    enum ParseErrors: Error {
        case unparsableList
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
        importance = PriorityChoices.getPriorityFrom(string: getValue(.importance) as? String ?? "")!
        deadline = Date.getDate(fromStringLocale: getValue(.deadline) as? String)
        guard let completed = getValue(.done) as? Bool else {
            return nil
        }
        self.done = completed
        if let hex = getValue(.color) as? String {
            self.color = Color(hex: hex)
        } else {
            self.color = nil
        }
        createdTime = Date.getDate(fromStringLocale: getValue(.createdTime) as? String) ?? Date.now
        changedTime = Date.getDate(fromStringLocale: getValue(.changedTime) as? String)
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
        if importance != .basic {
            setValue(.importance, importance.rawValue)
        }
        if deadline != nil {
            setValue(.deadline, deadline!.ISO8601Format())
        }
        setValue(.done, done ? "true" : "false")
        setValue(.createdTime, createdTime.ISO8601Format())
        if changedTime != nil {
            setValue(.changedTime, changedTime!.ISO8601Format())
        }
        return object
    }
    var json: Any {
        return (try? JSONSerialization.data(withJSONObject: dict)) ?? Data()
    }
    static func getList(from data: Any) throws -> [TodoItem] {
        guard let list = data as? [Any] else {
            throw ParseErrors.unparsableList
        }
        var ans = [TodoItem]()
        for item in list {
            if let parseItem = item as? [String: Any], let todoItem = TodoItem(dict: parseItem) {
                ans.append(todoItem)
            }
        }
        return ans
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
        switch string {
        case "true":
            return true
        case "false":
            return false
        default:
            return nil
        }
    }
}
