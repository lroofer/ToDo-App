//
//  URLSessionTesting.swift
//  ToDo AppTests
//
//  Created by Егор Колобаев on 12.07.2024.
//

import XCTest
@testable import ToDo_App

final class URLSessionTesting: XCTestCase {
    struct TestStruct: Codable {
        var id: Int
        var description: String
        var url: String
    }
    struct TestGroup: Codable {
        var results: [TestStruct]
    }
    // Test connection to the server
    func testBasicURLConnection() async throws {
        let url = URL(string: "https://api.sampleapis.com/codingresources/codingResources")
        XCTAssert(url != nil)
        let (data, response) = try await URLSession.shared.dataTask(for: .init(url: url!))
        let decoder = JSONDecoder()
        let json = try decoder.decode([TestStruct].self, from: data)
        XCTAssert(json.count == 173)
        XCTAssert(json.first?.url == "https://www.youtube.com/bocajs")
        let responseHTTP = response as? HTTPURLResponse
        XCTAssert(responseHTTP != nil)
        XCTAssert(responseHTTP!.statusCode == 200)
    }
}
