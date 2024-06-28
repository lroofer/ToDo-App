//
//  Todos.swift
//  ToDo App
//
//  Created by Егор Колобаев on 28.06.2024.
//

import Foundation

class Todos: ObservableObject {
    @Published private(set) var items = [String: TodoItem]() {
        didSet {
            // TODO: add caching
        }
    }
    @Published var countCompleted: Int
    func setItem(with id: String, value: TodoItem) {
        if let done = items[id]?.done {
            countCompleted -= done ? 1 : 0
        }
        items[id] = value
        countCompleted += value.done ? 1 : 0
    }
    func removeItem(with id: String) {
        items.removeValue(forKey: id)
    }
    init() {
        items = [:]
        countCompleted = 0
        let id = UUID().uuidString
        items[id] = TodoItem(id: id, text: "Test 1", importance: .important, deadline: .now.tommorow!, done: false, creationDate: .now, lastChangeDate: nil)
        let id_2 = UUID().uuidString
        items[id_2] = TodoItem(id: id_2, text: "Test 2", importance: .important, deadline: .distantPast, done: false, creationDate: .now, lastChangeDate: nil)
        for (_, value) in items {
            countCompleted += value.done ? 1 : 0
        }
        // TODO: try to decode from the cache
    }
}
