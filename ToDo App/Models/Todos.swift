//
//  Todos.swift
//  ToDo App
//
//  Created by Егор Колобаев on 28.06.2024.
//

import Foundation
import CocoaLumberjackSwift

final class Todos: ObservableObject, @unchecked Sendable {
    @Published private(set) var items = [String: TodoItem]()
    @Published var countCompleted: Int
    private let cache: FileCache
    private var isDirty = false
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
    @MainActor func setItem(with id: String, value: TodoItem, decoding: Bool = false) {
        if isDirty {
            fetchWithServer()
        }
        let isNew = items[id] == nil
        if let done = items[id]?.done {
            countCompleted -= done ? 1 : 0
        }
        items[id] = value
        cache.insert(value)
        DDLogInfo("Added to cache")
        countCompleted += value.done ? 1 : 0
        Task.detached { [self] in
            do {
                if isNew && !decoding {
                    DDLogDebug("Attempting to send new item to the server")
                    try await network.addTask(task: value)
                    DDLogDebug("Item \(value.id) was added to the server")
                } else if !decoding {
                    DDLogDebug("Updating \(id) task on server")
                    try await network.updateTask(taskID: id, task: value)
                    DDLogDebug("Item \(value.id) was updated on the server")
                    await fetchList()
                }
            } catch {
                DDLogError("There's been an error: \(error) with adding the item \(value.id) to the server")
                isDirty = true
            }
        }
        DDLogDebug("Task with id: \(id) has been updated")
    }
    func removeItem(with id: String) {
        if isDirty {
            fetchWithServer()
        }
        DDLogDebug("""
                   Task with id: \(id) has been removed locally
                   Sending a request to the server to delete it
                   """)
        guard let value = items[id] else {
            return
        }
        Task.detached { [self] in
            do {
                await cache.delete(value)
                DDLogDebug("Deleted from cache")
                try await network.deleteTask(taskID: id)
                DDLogDebug("Item \(id) has been deleted")
            } catch {
                DDLogError("There's been an error: \(error) with deleting the item \(id) to the server")
                isDirty = true
            }
        }
        items.removeValue(forKey: id)
    }
    @MainActor func saveItem(newItem: TodoItem) {
        DDLogDebug("An attempt to create Task with id: \(newItem.id)")
        setItem(with: newItem.id, value: newItem)
    }
    private func fetchList() async {
        items = [String: TodoItem]()
        countCompleted = 0
        await decodeFromCache()
    }
    private func fetchWithServer() {
        isDirty = false
        Task.detached { [self] in
            do {
                _ = try await network.getMerged(with: cache.fetch())
            } catch {
                DDLogInfo("Failed to fetch")
            }
        }
    }
    private func decodeFromCache() async {
        do {
            let cachedData = await cache.fetch()
            let data = try await network.getMerged(with: cachedData)
            for item in data.tasks {
                await setItem(with: item.id, value: item, decoding: true)
            }
        } catch {
            DDLogError("Decoding from cache error: \(error)")
        }
    }
    init() {
        items = [:]
        countCompleted = 0
        network = DefaultNetworkingService()
        cache = FileCache()!
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
