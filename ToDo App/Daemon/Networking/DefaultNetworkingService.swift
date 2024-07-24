//
//  DefaultNetworkingService.swift
//  ToDo App
//
//  Created by Егор Колобаев on 20.07.2024.
//

import Foundation

class DefaultNetworkingService: NetworkingService {
    let token: String = "Elurin"
    let url = "https://hive.mrdekk.ru/todo/"
    enum NetworkResponseErrors: Error {
        case unvalidURL(url: String)
        case unvalidResponseFromTheServer
        case unsuccessStatusCode(code: Int)
        case undetectableData
    }
    func getTasksList() async throws -> [TodoItem] {
        guard let urlAdress = URL(string: url + "list/") else {
            throw NetworkResponseErrors.unvalidURL(url: url + "list/")
        }
        var request = URLRequest(url: urlAdress)
        request.httpMethod = "GET"
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

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
        let list = try TodoItem.getList(from: responseJSON["list"] as Any)
        return list
    }
}
