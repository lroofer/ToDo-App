//
//  JsonParsing.swift
//  ToDo App
//
//  Created by Егор Колобаев on 19.06.2024.
//

import Foundation
import SwiftUI

extension TodoItem: JSONParsable {
    enum TodoItemStoredFields: String {
        case id
        case text
        case importance
        case deadline
        case done
        case color
        case createdTime = "created_at"
        case changedTime = "changed_at"
        case lastUpdatedBy = "last_updated_by"
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
    convenience init? (from data: Any) {
        guard let dict = data as? [String: Any] else {
            return nil
        }
        let getValue = { (identifier: TodoItemStoredFields) in dict[identifier.rawValue]
        }
        let id = (getValue(.id) as? String) ?? UUID().uuidString
        guard let text = getValue(.text) as? String else {
            return nil
        }
        let importance = PriorityChoices.getPriorityFrom(string: getValue(.importance) as? String ?? "")!
        let deadline: Date?
        if let deadlineTime = getValue(.deadline) as? Int64 {
            deadline = Date(timeIntervalSince1970: .init(deadlineTime))
        } else {
            deadline = nil
        }
        guard let completed = getValue(.done) as? Bool else {
            return nil
        }
        let done = completed
        let color: Color?
        if let hex = getValue(.color) as? String {
            color = Color(hex: hex)
        } else {
            color = nil
        }
        let createdTime: Date
        if let createdTimeInterval = getValue(.createdTime) as? Int64 {
            createdTime = Date(timeIntervalSince1970: .init(createdTimeInterval))
        } else {
            createdTime = .now
        }
        let changedTime: Date?
        if let changedTimeInterval = getValue(.changedTime) as? Int64 {
            changedTime = Date(timeIntervalSince1970: .init(changedTimeInterval))
        } else {
            changedTime = nil
        }
        self.init(id: id, text: text, importance: importance, deadline: deadline, done: done, color: color, creationDate: createdTime, lastChangeDate: changedTime)
    }
    static func parse(json: Any) -> TodoItem? {
        guard let jsonData = convertToData(json: json),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            return nil
        }
        return TodoItem(from: jsonObject)
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
        var object = [String: Any]()
        let setValue = {(identifier: TodoItemStoredFields, value: Any) in object[identifier.rawValue] = value}
        setValue(.id, id)
        setValue(.text, text)
        setValue(.importance, importance.rawValue)
        if deadline != nil {
            setValue(.deadline, Int64(deadline!.timeIntervalSince1970))
        }
        setValue(.done, done)
        setValue(.createdTime, Int64(createdTime.timeIntervalSince1970))
        if changedTime != nil {
            setValue(.changedTime, Int64(changedTime!.timeIntervalSince1970))
        }
        setValue(.lastUpdatedBy, UIDevice.current.identifierForVendor?.uuidString ?? "unknown")
        setValue(.color, color?.toHex() ?? "")
        return object
    }
    static func getList(from data: Any) throws -> [TodoItem] {
        guard let list = data as? [Any] else {
            throw ParseErrors.unparsableList
        }
        var ans = [TodoItem]()
        for item in list {
            if let parseItem = item as? [String: Any], let todoItem = TodoItem(from: parseItem) {
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
