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
    private var baseRequest: URLRequest {
        var request = URLRequest(url: url)
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    init(url: URL = URL(string: "https://hive.mrdekk.ru/todo/list")!, token: String = "Elurin") {
        self.url = url
        self.token = token
    }
    func getAllRequest() throws -> URLRequest {
        var request = baseRequest
        request.httpMethod = "GET"
        return request
    }
    func add(taskResponse: BasicResponse, revision: Int) async throws -> URLRequest {
        var request = URLRequest(url: URL(string: "https://hive.mrdekk.ru/todo/list")!)
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        DDLogInfo("Creating POST request to create TodoItem with revision: \(revision)")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: taskResponse.json)
        } catch {
            DDLogError("JSONSerilization error: \(error.localizedDescription)")
            throw error
        }
        return request
    }
}
