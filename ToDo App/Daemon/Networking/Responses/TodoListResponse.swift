//
//  TodoListResponse.swift
//  ToDo App
//
//  Created by Егор Колобаев on 24.07.2024.
//

import Foundation
import CocoaLumberjackSwift

struct TodoListResponse: BasicResponse {
    let status: String
    var result: any JSONParsable
    let revision: Int
    var json: Any {
        var object = [String: Any]()
        object["status"] = self.status
        object["list"] = self.result.json
        object["revision"] = self.revision
        return object
    }
    init(status: String, result: TodoItemList, revision: Int) {
        self.status = status
        self.result = result
        self.revision = revision
    }
    init?(from data: Any) {
        guard let dict = data as? [String: Any] else {
            return nil
        }
        guard let status = dict["status"] as? String else {
            return nil
        }
        guard let listParsed = dict["list"] as? [Any], let list = TodoItemList(from: listParsed) else {
            return nil
        }
        guard let revision = dict["revision"] as? Int else {
            return nil
        }
        self.status = status
        self.result = list
        self.revision = revision
    }
}
