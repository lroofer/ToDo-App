//
//  TodoItem.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import Foundation

struct TodoItem: Hashable {
    enum PriorityChoices: String {
        case low = "low"
        case ordinary = "ordinary"
        case high = "high"
        static func getPriorityFrom(string type: String) -> PriorityChoices? {
            switch(type) {
            case PriorityChoices.low.rawValue:
                return .low
            case "":
                fallthrough
            case PriorityChoices.ordinary.rawValue:
                return .ordinary
            case PriorityChoices.high.rawValue:
                return .high
            default:
                return nil
            }
        }
    }
    let id: String
    let text: String
    let priority: PriorityChoices
    let deadline: Date?
    let completed: Bool
    let creationDate: Date
    let lastChangeDate: Date?
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id
    }
    init(id: String?, text: String, priority: PriorityChoices, deadline: Date?, completed: Bool, creationDate: Date, lastChangeDate: Date?) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.completed = completed
        self.creationDate = creationDate
        self.lastChangeDate = lastChangeDate
    }
}
