//
//  FileCache.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import Foundation

class FileCache {
    private(set) var tasks: [String:TodoItem]
    
    init () {
        tasks = [String:TodoItem]()
    }
    
    /// Load all the tasks from the file.
    init? (contentsOf url: URL) {
        guard let jsonData = try? Data(contentsOf: url), let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            return nil
        }
        tasks = [String:TodoItem]()
        for dataObject in jsonObject {
            if let item = TodoItem(dict: dataObject) {
                tasks[item.id] = item
            }
        }
    }
    
    /// Prepare and encode data to the JSON.
    private func exportAllData() -> Data? {
        var data = [[String : Any]]()
        for (_, element) in tasks {
            data.append(element.dict)
        }
        return try? JSONSerialization.data(withJSONObject: data)
    }
    
    func addNew(task: TodoItem) {
        tasks[task.id] = task
    }
    
    func deleteTask(with id: String) -> TodoItem? {
        let item = tasks[id]
        if item != nil {
            tasks.removeValue(forKey: id)
        }
        return item
    }
    
    /// Exports encoded data into the given file.
    func saveAllData(to file: URL) throws {
        let data = exportAllData() ?? Data()
        try data.write(to: file)
    }
    
}
