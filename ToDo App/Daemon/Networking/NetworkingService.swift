//
//  NetworkingService.swift
//  ToDo App
//
//  Created by Егор Колобаев on 20.07.2024.
//

import Foundation

protocol NetworkingService {
    func getTasksList() async throws -> TodoItemList
    func addTask(task: TodoItem) async throws
    func deleteTask(taskID: String) async throws
    func updateTask(taskID: String, task: TodoItem) async throws
    func fetchList(todos: TodoItemList) async throws -> TodoItemList
    func getMerged(with: TodoItemList) async throws -> TodoItemList
}
