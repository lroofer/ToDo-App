//
//  Service.swift
//  ToDo App
//
//  Created by Егор Колобаев on 12.07.2024.
//

import Foundation

extension URLSession {
    enum URLSessionErrorResponse: Error {
        case invalidURL(url: URL?)
        case invalidServerResponse(responseCode: HTTPURLResponse?)
        case invalidData
    }
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        self.getAllTasks { lastUrlSessions in
            for session in lastUrlSessions {
                session.cancel()
            }
        }
        guard urlRequest.url != nil else { throw  URLSessionErrorResponse.invalidURL(url: nil) }
        var dataCollected: Data?
        var urlResponse: URLResponse?
        var error: Error?
        let mutex = NSLock()
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .userInteractive).async {
            self.dataTask(with: urlRequest) { dataGet, urlResponseGet, errorGet in
                mutex.withLock {
                    dataCollected = dataGet
                    urlResponse = urlResponseGet
                    error = errorGet
                }
            }.resume()
        }
        group.wait(timeout: .now() + 5)
        if let dataCollected, let urlResponse, error == nil {
            return (dataCollected, urlResponse)
        }
        if let error {
            throw error
        }
        throw URLSessionErrorResponse.invalidServerResponse(responseCode: (urlResponse as? HTTPURLResponse))
    }
}
