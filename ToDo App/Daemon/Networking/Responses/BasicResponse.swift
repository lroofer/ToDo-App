//
//  BasicResponse.swift
//  ToDo App
//
//  Created by Егор Колобаев on 25.07.2024.
//

import Foundation

protocol BasicResponse: JSONParsable {
    var status: String { get }
    var result: JSONParsable { get }
    var revision: Int { get }
    var json: Any { get }
}
