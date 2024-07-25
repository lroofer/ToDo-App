//
//  NetworkingService.swift
//  ToDo App
//
//  Created by Егор Колобаев on 20.07.2024.
//

import Foundation

protocol NetworkingService {
    func getTasksList() async throws -> TodoItemList
}
