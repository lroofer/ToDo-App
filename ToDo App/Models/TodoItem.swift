//
//  TodoItem.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class TodoItem: Hashable, Identifiable, Sendable {
    enum PriorityChoices: String, Codable {
        case low
        case basic
        case important
        static func getPriorityFrom(string type: String) -> PriorityChoices? {
            switch type {
            case PriorityChoices.low.rawValue:
                return .low
            case "":
                fallthrough
            case PriorityChoices.basic.rawValue:
                return .basic
            case PriorityChoices.important.rawValue:
                return .important
            default:
                return nil
            }
        }
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id
    }
    @Attribute(.unique) let id: String
    let text: String
    let importance: PriorityChoices
    let deadline: Date?
    let done: Bool
    @Transient var color: Color? = nil
    @Attribute(originalName: "created_at") let createdTime: Date
    @Attribute(originalName: "changed_at") let changedTime: Date?
    init(id: String?, text: String, importance: PriorityChoices, deadline: Date?, done: Bool,
         color: Color?, creationDate: Date, lastChangeDate: Date?) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.done = done
        self.color = color
        self.createdTime = creationDate
        self.changedTime = lastChangeDate
    }
    init() {
        self.id = UUID().uuidString
        self.text = ""
        self.importance = .basic
        self.deadline = .now.nextDay
        self.done = false
        self.color = nil
        self.createdTime = .now
        self.changedTime = .now
    }
}

extension TodoItem {
    var getCompleted: TodoItem {
        return TodoItem(id: id, text: text, importance: importance, deadline: deadline,
                        done: true, color: color, creationDate: createdTime, lastChangeDate: changedTime)
    }
    var getIncompleted: TodoItem {
        return TodoItem(id: id, text: text, importance: importance, deadline: deadline,
                        done: false, color: color, creationDate: createdTime, lastChangeDate: changedTime)
    }
}
