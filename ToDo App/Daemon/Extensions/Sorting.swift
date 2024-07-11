//
//  Sorting.swift
//  ToDo App
//
//  Created by Егор Колобаев on 09.07.2024.
//

import Foundation

extension Todos {
    func getSorted(by preferImportance: Bool) -> [Dictionary<String, TodoItem>.Element] {
        self.items.sorted { a, b in
            if preferImportance && a.value.importance != b.value.importance {
                return a.value.importance == .important || (a.value.importance == .basic && b.value.importance == .low)
            }
            return a.value.createdTime > b.value.createdTime
        }
    }
}
