//
//  FileCache.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import Foundation

class FileCache {
    private(set) var items: Set<TodoItem>
    
    init? (contentsOf url: URL) {
        guard let jsonData = try? Data(contentsOf: url), let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [TodoItem] else {
            return nil
        }
        items = Set<TodoItem>()
        for dataObject in jsonObject {
            items.insert(dataObject)
        }
    }
    
    init () {
        items = Set<TodoItem>()
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func exportAllData() -> Data? {
        var data = [Data]()
        for element in items {
            if let element = element.json as? Data {
                data.append(element)
            }
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
    
    func saveAllData(to file: String) throws {
        let data = exportAllData() ?? Data()
        let filename = getDocumentsDirectory().appendingPathComponent(file)
        try data.write(to: filename)
    }
    
}
