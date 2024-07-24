//
//  APICaller.swift
//  ToDo App
//
//  Created by Егор Колобаев on 24.07.2024.
//

import Foundation
import CocoaLumberjackSwift

struct APICaller {
    private let baseURL: URL
    private let token: String
    private let pathComponent = "list"
    
    init(baseURL: URL = URL(string: "https://hive.mrdekk.ru/todo/")!, token: String = "Elurin") {
        self.baseURL = baseURL
        self.token = token
        DDLogInfo("APICaller initialized with baseURL: \(baseURL) and token: \(token)")
    }
    
    private var url: URL {
        return baseURL.appendingPathComponent(pathComponent)
    }
    
    
}
