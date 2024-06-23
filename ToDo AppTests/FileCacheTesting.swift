//
//  FileCacheTesting.swift
//  ToDo AppTests
//
//  Created by Егор Колобаев on 22.06.2024.
//

import Foundation
import XCTest
@testable import ToDo_App

final class FileCacheTesting: XCTestCase {
    
    func testFetching() async throws {
        let fileCache = FileCache()
        let task1 = TodoItem(id: nil, text: "Task 1", priority: .low, deadline: nil, completed: false, creationDate: .now, lastChangeDate: nil)
        fileCache.addNew(task: task1)
        fileCache.addNew(task: TodoItem(id: nil, text: "Task 2", priority: .high, deadline: .now, completed: false, creationDate: .now, lastChangeDate: .now))
        fileCache.addNew(task: task1)
        XCTAssert(fileCache.tasks.count == 2)
        _ = fileCache.deleteTask(with: task1.id)
        XCTAssert(fileCache.tasks.count == 1)
        fileCache.addNew(task: task1)
        XCTAssert(fileCache.tasks.count == 2)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let filename = paths[0].appendingPathComponent("test_2.csv")
        
        try fileCache.saveAllData(to: filename)
        _ = FileCache(contentsOf: filename)
        XCTAssert(fileCache.tasks.count == 2)
    }
    
}
