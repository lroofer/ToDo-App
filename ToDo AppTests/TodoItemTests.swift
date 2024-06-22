//
//  TodoItemTests.swift
//  ToDo AppTests
//
//  Created by Егор Колобаев on 22.06.2024.
//

import Testing
import Foundation
@testable import ToDo_App

struct TodoItemTests {
    
    @Test("Convertion")
    func testPriorityCalculation() async throws {
        #expect(TodoItem.PriorityChoices.getPriorityFrom(string: "") == .ordinary)
        #expect(TodoItem.PriorityChoices.getPriorityFrom(string: "low") == .low)
        #expect(TodoItem.PriorityChoices.getPriorityFrom(string: "ordinary") == .ordinary)
        #expect(TodoItem.PriorityChoices.getPriorityFrom(string: "high") == .high)
        #expect(TodoItem.PriorityChoices.getPriorityFrom(string: "test") == nil)
    }
    
    @Test("Ability to distinct elements by id")
    func testForEquality() async throws {
        var listOfItems = Set<TodoItem>()
        let object = TodoItem(id: nil, text: "First text", priority: .low, deadline: nil, completed: false, creationDate: Date.now, lastChangeDate: nil)
        listOfItems.insert(object)
        listOfItems.insert(object)
        let modifiedObject = TodoItem(id: object.id, text: "Second text", priority: .low, deadline: nil, completed: false, creationDate: Date.now, lastChangeDate: nil)
        listOfItems.insert(modifiedObject)
        #expect(listOfItems.count == 1)
        listOfItems.insert(TodoItem(id: nil, text: "First text", priority: .low, deadline: nil, completed: false, creationDate: Date.now, lastChangeDate: nil))
        #expect(listOfItems.count == 2)
    }
    
    @Test("Parsing json")
    func testParseJson() async throws {
        let jsonFileUrl_1 = Bundle.main.url(forResource: "test_1", withExtension: "json")!
        let jsonFileUrl_2 = Bundle.main.url(forResource: "test_2", withExtension: "json")!
        let item_1 = TodoItem.parse(json: try Data(contentsOf: jsonFileUrl_1))!
        #expect(item_1.id == "29D4B96B-2F6D-4F6C-AC99-0C1915AD414A")
        #expect(item_1.text == "Attempted testing")
        #expect(item_1.priority == .low)
        #expect(item_1.completed == true)
        let item_2 = TodoItem.parse(json: try String(contentsOf: jsonFileUrl_2, encoding: .utf8))!
        #expect(item_2.id == "29D4B96B-2F6D-4F6C-AC99-0C1915AD414A")
        #expect(item_2.text == "Attempted testing")
        #expect(item_2.priority == .ordinary)
        #expect(item_2.completed == false)
    }
    
    @Test("Encoder to json")
    func testEncoding() async throws {
        let item = TodoItem(id: nil, text: "Testing", priority: .low, deadline: .now, completed: false, creationDate: .now, lastChangeDate: nil)
        let jsonParsedObject = item.json as? Data
        #expect(jsonParsedObject != nil)
        let itemGet = TodoItem.parse(json: item.json)
        #expect(itemGet != nil)
        #expect(itemGet!.id == item.id)
        #expect(itemGet!.text == item.text)
        #expect(itemGet!.priority == item.priority)
        #expect(itemGet!.deadline?.description == item.deadline?.description)
        #expect(itemGet!.creationDate.description == item.creationDate.description)
        #expect(itemGet!.lastChangeDate?.description == item.lastChangeDate?.description)
        #expect(itemGet!.completed == item.completed)
    }
    
    @Test("CSV unpacking")
    func testCsvDecoding() async throws {
        let fileUrl = Bundle.main.url(forResource: "test", withExtension: "csv")!
        let items = try TodoItem.getSetOfItemsFrom(csvFile: fileUrl, linesOfHeader: 1)
        #expect(items.count == 2)
        for element in items {
            if element.id == "uu1" {
                #expect(element.text == "Test message, afterwards")
                #expect(element.priority == .low)
                #expect(element.deadline?.ISO8601Format() == "2016-04-14T10:44:00Z")
                #expect(!element.completed)
                #expect(element.lastChangeDate?.ISO8601Format() == "2017-04-14T10:44:00Z")
            } else {
                #expect(element.text == "Wrong message")
                #expect(element.completed)
            }
            #expect(element.creationDate.ISO8601Format() == "2016-04-14T10:44:00Z")
        }
    }
    
}
