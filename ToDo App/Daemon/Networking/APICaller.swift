//
//  APICaller.swift
//  ToDo App
//
//  Created by Егор Колобаев on 25.07.2024.
//

import Foundation
import CocoaLumberjackSwift

struct APICaller {
    enum NetworkResponseErrors: Error {
        case invalidURL(url: String)
        case invalidResponseFromTheServer
        case unsuccessStatusCode(code: Int)
        case undetectableData
    }
    func perform(request: URLRequest, session: URLSession) async throws -> BasicResponse {
        let (data, response) = try await session.data(for: request)
        DDLogDebug("\(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
        DDLogDebug("\(request.allHTTPHeaderFields ?? "NONE")")
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkResponseErrors.invalidResponseFromTheServer
        }
        DDLogDebug("\(httpResponse.statusCode)")
        if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
            throw NetworkResponseErrors.unsuccessStatusCode(code: httpResponse.statusCode)
        }
        DDLogDebug("\(String(data: data, encoding: .utf8) ?? "s")")
        guard let responseJSON = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
            throw NetworkResponseErrors.undetectableData
        }
        DDLogDebug("\(responseJSON)")
        if responseJSON.keys.contains("list"), let response = TodoListResponse(from: responseJSON) {
            return response
        }
        if let response = TodoItemResponse(from: responseJSON) {
            return response
        }
        throw NetworkResponseErrors.undetectableData
    }
}
