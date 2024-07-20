//
//  Sorting.swift
//  ToDo App
//
//  Created by Егор Колобаев on 09.07.2024.
//

import Foundation

extension Todos {
    func getSorted(by preferImportance: Bool) -> [Dictionary<String, TodoItem>.Element] {
        self.items.sorted { left, right in
            if preferImportance && left.value.importance != right.value.importance {
                return left.value.importance == .important || (left.value.importance ==
                    .basic && right.value.importance == .low)
            }
            return left.value.createdTime > right.value.createdTime
        }
    }
}
