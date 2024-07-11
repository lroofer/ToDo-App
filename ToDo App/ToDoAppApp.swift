//
//  ToDo_AppApp.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import SwiftUI

@main
struct ToDoAppApp: App {
    static var idiom: UIUserInterfaceIdiom {
        UIDevice.current.userInterfaceIdiom
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: initLogger)
        }
    }

}
