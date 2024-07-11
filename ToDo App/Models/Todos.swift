//
//  Todos.swift
//  ToDo App
//
//  Created by Егор Колобаев on 28.06.2024.
//

import Foundation
import CocoaLumberjackSwift

class Todos: ObservableObject {
    @Published private(set) var items = [String: TodoItem]() {
        didSet {
            // TODO: add caching
        }
    }
    @Published var countCompleted: Int
    var groupedTasks: [Int: [TodoItem]] {
        var dict = [Int:[TodoItem]]()
        for task in items {
            if let deadline = task.value.deadline {
                dict[deadline.components, default: []].append(task.value)
            } else {
                dict[0, default: []].append(task.value)
            }
        }
        return dict
    }
    func setItem(with id: String, value: TodoItem) {
        if let done = items[id]?.done {
            countCompleted -= done ? 1 : 0
        }
        items[id] = value
        countCompleted += value.done ? 1 : 0
        DDLogDebug("Task with id: \(id) has been updated")
    }
    func removeItem(with id: String) {
        DDLogDebug("Task with id: \(id) has been removed")
        items.removeValue(forKey: id)
    }
    func saveItem(newItem: TodoItem) {
        DDLogDebug("An attempt to create Task with id: \(newItem.id)")
        setItem(with: newItem.id, value: newItem)
    }
    init() {
        items = [:]
        countCompleted = 0
        let id = UUID().uuidString
        items[id] = TodoItem(id: id, text: "Test 1", importance: .important, deadline: .now.nextDay!, done: false, color: .red, creationDate: .now, lastChangeDate: nil)
        let id_2 = UUID().uuidString
        items[id_2] = TodoItem(id: id_2, text: "Test 2", importance: .important, deadline: .distantPast, done: false, color: .blue, creationDate: .now, lastChangeDate: nil)
        for (_, value) in items {
            countCompleted += value.done ? 1 : 0
        }
        // TODO: try to decode from the cache
    }
}


extension Todos {
    var sortedDates: [Int] {
        groupedTasks.keys.sorted()
    }
}
