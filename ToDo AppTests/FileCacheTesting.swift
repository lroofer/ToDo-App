//
//  FileCacheTesting.swift
//  ToDo AppTests
//
//  Created by Егор Колобаев on 22.06.2024.
//

import Foundation
import Testing
@testable import ToDo_App

struct FileCacheTesting {

    @Test func testFetching() async throws {
        let fileCache = FileCache()
        fileCache.addNew(task: TodoItem(id: nil, text: "Task 1", priority: .low, deadline: nil, completed: false, creationDate: .now, lastChangeDate: nil))
        fileCache.addNew(task: TodoItem(id: nil, text: "Task 2", priority: .high, deadline: .now, completed: false, creationDate: .now, lastChangeDate: .now))
        fileCache.addNew(task: fileCache.items[fileCache.items.startIndex])
        #expect(fileCache.items.count == 2)
        fileCache.deleteTask(with: fileCache.items[fileCache.items.startIndex].id)
        #expect(fileCache.items.count == 1)
        fileCache.addNew(task: TodoItem(id: nil, text: "Task 1", priority: .low, deadline: nil, completed: false, creationDate: .now, lastChangeDate: nil))
        #expect(fileCache.items.count == 2)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let filename = paths[0].appendingPathComponent("test_2.csv")
        
        try fileCache.saveAllData(to: filename)
        let fileCache_exported = FileCache(contentsOf: filename)
        #expect(fileCache.items.count == 2)
    }

}
