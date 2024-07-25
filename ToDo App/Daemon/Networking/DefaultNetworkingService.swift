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
    private let session = URLSession(configuration: .default)
    private var lastKnownRevision = 0
    func getTasksList() async throws -> TodoItemList {
        let request = try requestFactory.getAllRequest()
        let response = try await caller.perform(request: request, session: session)
        lastKnownRevision = response.revision
        guard let list = response.result as? TodoItemList else {
            throw RequestErrors.unparsableResult
        }
        return list
    }
    func addTask(task: TodoItem) async throws {
        let requestData = TodoItemResponse(status: "ok", result: task, revision: lastKnownRevision)
        let request = try await requestFactory.add(taskResponse: requestData, revision: lastKnownRevision)
        let response = try await caller.perform(request: request, session: session)
        // TODO: Check for the completion.
    }
}
