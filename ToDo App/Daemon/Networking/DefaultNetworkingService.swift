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
        case unparsableResult, unparsableListOfItems
    }
    private let requestFactory = RequestFactory()
    private let caller = APICaller()
    private let session = URLSession(configuration: .default)
    private var lastKnownRevision = 0
    func getTasksList() async throws -> TodoItemList {
        let request = try requestFactory.getAllRequest()
        log(request: request)
        let response = try await caller.perform(request: request, session: session)
        lastKnownRevision = response.revision
        guard let list = response.result as? TodoItemList else {
            throw RequestErrors.unparsableResult
        }
        return list
    }
    func addTask(task: TodoItem) async throws {
        let request = try await requestFactory.add(taskResponse: request(for: task), revision: lastKnownRevision)
        log(request: request, for: "Adding item \(task.id)")
        let response = try await caller.perform(request: request, session: session)
        lastKnownRevision = response.revision
        // TODO: Check for the completion.
    }
    func deleteTask(taskID: String) async throws {
        let request = try await requestFactory.remove(taskID: taskID, revision: lastKnownRevision)
        log(request: request, for: "Delete item \(taskID)")
        let response = try await caller.perform(request: request, session: session)
        lastKnownRevision = response.revision
    }
    func updateTask(taskID: String, task: TodoItem) async throws {
        let request = try await requestFactory.updateItem(taskID: taskID, taskResponse: request(for: task), revision: lastKnownRevision)
        log(request: request, for: "Updating item \(task.id)")
        let response = try await caller.perform(request: request, session: session)
        lastKnownRevision = response.revision
    }
    func fetchList(todos: TodoItemList) async throws -> TodoItemList {
        let request = try await requestFactory.fetch(taskListResponse: request(with: todos), revision: lastKnownRevision)
        log(request: request, for: "Fetching")
        let response = try await caller.perform(request: request, session: session)
        lastKnownRevision = response.revision
        guard let list = response.result as? TodoItemList else {
            throw RequestErrors.unparsableListOfItems
        }
        return list
    }
    func getMerged(with cache: TodoItemList) async throws -> TodoItemList {
        do {
            let list = try await getTasksList()
            var dict = [String: TodoItem]()
            for task in list.tasks {
                dict[task.id] = task
            }
            for task in cache.tasks {
                if dict[task.id] == nil {
                    try await addTask(task: task)
                }
            }
            return try await getTasksList()
        } catch {
            DDLogError("Network connection error: \(error). Using cache")
            return cache
        }
    }
}

fileprivate extension DefaultNetworkingService {
    func log(request: URLRequest, for description: String = "NONE") {
        var body: String = "None"
        if let httpBody = request.httpBody {
            if httpBody.count <= 200 {
                body = String(data: httpBody, encoding: .utf8) ?? "ENCRYPTED"
            } else {
                body = "\(httpBody.count) bytes"
            }
        }
        DDLogInfo("""
            Got request with task: \(description)
            ------------------------------------
            URL: \(request.url?.absoluteString ?? "<None>")
            httpMethod: \(request.httpMethod ?? "<None>")
            httpBody: \(body)
            headers: \(request.allHTTPHeaderFields ?? "NO")
        """)
    }
}

fileprivate extension DefaultNetworkingService {
    func request(for task: TodoItem) -> TodoItemResponse {
        TodoItemResponse(status: "ok", result: task, revision: lastKnownRevision)
    }
    func request(with list: TodoItemList) -> TodoListResponse {
        TodoListResponse(status: "ok", result: list, revision: lastKnownRevision)
    }
}
