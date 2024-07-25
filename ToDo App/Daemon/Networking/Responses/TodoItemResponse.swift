//
//  TodoItemResponse.swift
//  ToDo App
//
//  Created by Егор Колобаев on 24.07.2024.
//

import Foundation

struct TodoItemResponse: BasicResponse {
    init?(from data: Any) {
        guard let dict = data as? [String: Any] else {
            return nil
        }
        guard let status = dict["status"] as? String else {
            return nil
        }
        guard let itemParsed = dict["element"] as? [String: Any], let item = TodoItem(from: itemParsed) else {
            return nil
        }
        guard let revision = dict["revision"] as? Int else {
            return nil
        }
        self.status = status
        self.result = item
        self.revision = revision
    }
    
    let status: String
    let result: any JSONParsable
    let revision: Int
    var json: Any {
        var object = [String: Any]()
        object["status"] = status
        object["element"] = result.json
        object["revision"] = revision
        return object
    }
}
