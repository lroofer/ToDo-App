//
//  FileCache.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import Foundation

class FileCache {
    private(set) var items: Set<TodoItem>
    
    init () {
        items = Set<TodoItem>()
    }
    
    init? (contentsOf url: URL) {
        guard let jsonData = try? Data(contentsOf: url), let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            return nil
        }
        items = Set<TodoItem>()
        for dataObject in jsonObject {
            if let item = TodoItem(dict: dataObject) {
                items.insert(item)
            }
        }
    }
    
    private func exportAllData() -> Data? {
        var data = [[String : Any]]()
        for element in items {
            data.append(element.dict)
        }
        return try? JSONSerialization.data(withJSONObject: data)
    }
    
    func addNew(task: TodoItem) {
        items.insert(task)
    }
    
    func deleteTask(with id: String) {
        for element in items {
            if element.id == id {
                items.remove(element)
                return
            }
        }
    }
    
    func saveAllData(to file: URL) throws {
        let data = exportAllData() ?? Data()
        try data.write(to: file)
    }
    
}
