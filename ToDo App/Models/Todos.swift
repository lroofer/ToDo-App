//
//  Todos.swift
//  ToDo App
//
//  Created by Егор Колобаев on 28.06.2024.
//

import Foundation
import CocoaLumberjackSwift

final class Todos: ObservableObject, @unchecked Sendable {
    @Published private(set) var items = [String: TodoItem]() {
        didSet {
            // TODO: add caching
        }
    }
    @Published var countCompleted: Int
    private let network: NetworkingService
    var groupedTasks: [Int: [TodoItem]] {
        var dict = [Int: [TodoItem]]()
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
    private func decodeFromCache() async {
        do {
            let data = try await network.getTasksList()
            for item in data.tasks {
                setItem(with: item.id, value: item)
            }
        } catch {
            DDLogError("Decoding from cache error: \(error)")
        }
    }
    init() {
        items = [:]
        countCompleted = 0
        network = DefaultNetworkingService()
        Task.detached { [self] in
            await decodeFromCache()
        }
    }
}

extension Todos {
    var sortedDates: [Int] {
        groupedTasks.keys.sorted()
    }
}
