//
//  APICaller.swift
//  ToDo App
//
//  Created by Егор Колобаев on 25.07.2024.
//

import Foundation
import CocoaLumberjackSwift

struct RequestFactory {
    private let url: URL
    private let token: String
    private func baseRequest(with method: String, revision: Int? = nil, adding component: String? = nil, httpBody: Data? = nil) -> URLRequest {
        var parseURL = url
        if let component {
            parseURL = parseURL.appendingPathComponent(component)
        }
        var request = URLRequest(url: parseURL)
        request.httpMethod = method
        request.httpBody = httpBody
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let revision {
            request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        }
        return request
    }
    init(url: URL = URL(string: "https://hive.mrdekk.ru/todo/list")!, token: String = "Elurin") {
        self.url = url
        self.token = token
    }
    func getAllRequest() throws -> URLRequest {
        baseRequest(with: "GET")
    }
    func add(taskResponse: BasicResponse, revision: Int) async throws -> URLRequest {
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: taskResponse.json)
            return baseRequest(with: "POST", revision: revision, httpBody: httpBody)
        } catch {
            DDLogError("JSONSerilization error: \(error)")
            throw error
        }
    }
    func updateItem(taskID: String, taskResponse: BasicResponse, revision: Int) async throws -> URLRequest {
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: taskResponse.json)
            return baseRequest(with: "PUT", revision: revision, adding: taskID, httpBody: httpBody)
        } catch {
            DDLogError("Can't encrypt the item \(taskID): \(error)")
            throw error
        }
    }
    func remove(taskID: String, revision: Int) async throws -> URLRequest {
        baseRequest(with: "DELETE", revision: revision, adding: taskID)
    }
    func fetch(taskListResponse: BasicResponse, revision: Int) async throws -> URLRequest {
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: taskListResponse.json)
            return baseRequest(with: "PATCH", revision: revision, httpBody: httpBody)
        } catch {
            DDLogError("Can't encrypt the list of items")
            throw error
        }
    }
}
