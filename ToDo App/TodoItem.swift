//
//  TodoItem.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import Foundation

struct TodoItem: Hashable {
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
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id
    }
}
