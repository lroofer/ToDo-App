//
//  NetworkingService.swift
//  ToDo App
//
//  Created by Егор Колобаев on 20.07.2024.
//

import Foundation

protocol NetworkingService {
    var token: String { get }
    var url: String { get }
    
    func getTasksList() async throws -> [TodoItem]
}
