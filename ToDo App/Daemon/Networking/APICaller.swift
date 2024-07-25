//
//  APICaller.swift
//  ToDo App
//
//  Created by Егор Колобаев on 25.07.2024.
//

import Foundation

struct APICaller {
    enum NetworkResponseErrors: Error {
        case unvalidURL(url: String)
        case unvalidResponseFromTheServer
        case unsuccessStatusCode(code: Int)
        case undetectableData
    }
    func perform(request: URLRequest) async throws -> BasicResponse {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkResponseErrors.unvalidResponseFromTheServer
        }
        if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
            throw NetworkResponseErrors.unsuccessStatusCode(code: httpResponse.statusCode)
        }
        guard let responseJSON = (try JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
            throw NetworkResponseErrors.undetectableData
        }
        if responseJSON.keys.contains("list"), let response = TodoListResponse(from: responseJSON) {
            return response
        }
        if let response = TodoItemResponse(from: responseJSON) {
            return response
        }
        throw NetworkResponseErrors.undetectableData
    }
}
