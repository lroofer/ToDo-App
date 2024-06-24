//
//  TodoItemTests.swift
//  ToDo AppTests
//
//  Created by Егор Колобаев on 22.06.2024.
//

import XCTest
import Foundation
@testable import ToDo_App

final class TodoItemTests: XCTestCase {
    
    // Convertion test
    func testPriorityCalculation() async throws {
        XCTAssert(TodoItem.PriorityChoices.getPriorityFrom(string: "") == .basic)
        XCTAssert(TodoItem.PriorityChoices.getPriorityFrom(string: "low") == .low)
        XCTAssert(TodoItem.PriorityChoices.getPriorityFrom(string: "ordinary") == .basic)
        XCTAssert(TodoItem.PriorityChoices.getPriorityFrom(string: "high") == .important)
        XCTAssert(TodoItem.PriorityChoices.getPriorityFrom(string: "test") == nil)
    }
    
    // Test the Ability to distinct elements by id
    func testForEquality() async throws {
        var listOfItems = Set<TodoItem>()
        let object = TodoItem(id: nil, text: "First text", importance: .low, deadline: nil, done: false, creationDate: Date.now, lastChangeDate: nil)
        listOfItems.insert(object)
        listOfItems.insert(object)
        let modifiedObject = TodoItem(id: object.id, text: "Second text", importance: .low, deadline: nil, done: false, creationDate: Date.now, lastChangeDate: nil)
        listOfItems.insert(modifiedObject)
        XCTAssert(listOfItems.count == 1)
        listOfItems.insert(TodoItem(id: nil, text: "First text", importance: .low, deadline: nil, done: false, creationDate: Date.now, lastChangeDate: nil))
        XCTAssert(listOfItems.count == 2)
    }
    
    // Test Parsing json
    func testParseJson() async throws {
        let jsonFileUrl_1 = Bundle.main.url(forResource: "test_1", withExtension: "json")!
        let jsonFileUrl_2 = Bundle.main.url(forResource: "test_2", withExtension: "json")!
        let item_1 = TodoItem.parse(json: try Data(contentsOf: jsonFileUrl_1))!
        XCTAssert(item_1.id == "29D4B96B-2F6D-4F6C-AC99-0C1915AD414A")
        XCTAssert(item_1.text == "Attempted testing")
        XCTAssert(item_1.importance == .low)
        XCTAssert(item_1.done == true)
        let item_2 = TodoItem.parse(json: try String(contentsOf: jsonFileUrl_2, encoding: .utf8))!
        XCTAssert(item_2.id == "29D4B96B-2F6D-4F6C-AC99-0C1915AD414A")
        XCTAssert(item_2.text == "Attempted testing")
        XCTAssert(item_2.importance == .basic)
        XCTAssert(item_2.done == false)
    }
    
    // TestEncoder to json
    func testEncoding() async throws {
        let item = TodoItem(id: nil, text: "Testing", importance: .low, deadline: .now, done: false, creationDate: .now, lastChangeDate: nil)
        let jsonParsedObject = item.json as? Data
        XCTAssert(jsonParsedObject != nil)
        let itemGet = TodoItem.parse(json: item.json)
        XCTAssert(itemGet != nil)
        XCTAssert(itemGet!.id == item.id)
        XCTAssert(itemGet!.text == item.text)
        XCTAssert(itemGet!.importance == item.importance)
        XCTAssert(itemGet!.deadline?.description == item.deadline?.description)
        XCTAssert(itemGet!.createdTime.description == item.createdTime.description)
        XCTAssert(itemGet!.changedTime?.description == item.changedTime?.description)
        XCTAssert(itemGet!.done == item.done)
    }
    
    // TestCSV unpacking
    func testCsvDecoding() async throws {
        let fileUrl = Bundle.main.url(forResource: "test", withExtension: "csv")!
        let items = try TodoItem.getSetOfItemsFrom(csvFile: fileUrl, linesOfHeader: 1)
        XCTAssert(items.count == 2)
        for element in items {
            if element.id == "uu1" {
                XCTAssert(element.text == "Test message, afterwards")
                XCTAssert(element.importance == .low)
                XCTAssert(element.deadline?.ISO8601Format() == "2016-04-14T10:44:00Z")
                XCTAssert(!element.done)
                XCTAssert(element.changedTime?.ISO8601Format() == "2017-04-14T10:44:00Z")
            } else {
                XCTAssert(element.text == "Wrong message")
                XCTAssert(element.done)
            }
            XCTAssert(element.createdTime.ISO8601Format() == "2016-04-14T10:44:00Z")
        }
    }
    
}
