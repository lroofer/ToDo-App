//
//  TodoListResponse.swift
//  ToDo App
//
//  Created by Егор Колобаев on 24.07.2024.
//

import Foundation
import CocoaLumberjackSwift

struct TodoListResponse {
    let status: String
    let result: [TodoItem]
    let revision: Int
}
