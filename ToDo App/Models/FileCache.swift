//
//  FileCache.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import Foundation
import SwiftData

actor FileCache {
    private let modelContainer: ModelContainer
    init? () {
        let schema = Schema([TodoItem.self])
        guard let container = try? ModelContainer(for: schema) else {
            return nil
        }
        self.modelContainer = container
    }
    @MainActor public func fetchNotCompleted() -> TodoItemList {
        let fetchDescriptor = FetchDescriptor<TodoItem>(predicate: #Predicate { item in
            !item.done
        })
        return TodoItemList(tasks: (try? modelContainer.mainContext.fetch(fetchDescriptor)) ?? [])
    }
    @MainActor public func fetch() -> TodoItemList {
        let fetchDescriptor = FetchDescriptor<TodoItem>(sortBy: [.init(\.createdTime)])
        return TodoItemList(tasks: (try? modelContainer.mainContext.fetch(fetchDescriptor)) ?? [])
    }
    @MainActor public func insert(_ todoItem: TodoItem) {
        modelContainer.mainContext.insert(todoItem)
    }
    @MainActor public func delete(_ todoItem: TodoItem) {
        modelContainer.mainContext.delete(todoItem)
    }
    @MainActor public func update(_ todoItem: TodoItem) {
        insert(todoItem)
    }
    
}
