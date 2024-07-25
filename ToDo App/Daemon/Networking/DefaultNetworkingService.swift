//
//  DefaultNetworkingService.swift
//  ToDo App
//
//  Created by Егор Колобаев on 20.07.2024.
//

import Foundation
import CocoaLumberjackSwift

class DefaultNetworkingService: NetworkingService {
    enum RequestErrors: Error {
        case unparsableResult
    }
    private let requestFactory = RequestFactory()
    private let caller = APICaller()
    func getTasksList() async throws -> TodoItemList {
        let request = try requestFactory.getAllRequest()
        let response = try await caller.perform(request: request)
        guard let list = response.result as? TodoItemList else {
            throw RequestErrors.unparsableResult
        }
        return list
    }
}
