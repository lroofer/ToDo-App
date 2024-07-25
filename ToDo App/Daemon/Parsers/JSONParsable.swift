//
//  JSONParsable.swift
//  ToDo App
//
//  Created by Егор Колобаев on 25.07.2024.
//

import Foundation

protocol JSONParsable {
    var json: Any { get }
    init? (from: Any)
}
