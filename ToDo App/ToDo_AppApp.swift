//
//  ToDo_AppApp.swift
//  ToDo App
//
//  Created by Егор Колобаев on 18.06.2024.
//

import SwiftUI

@main
struct ToDo_AppApp: App {
    static var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some Scene {
        WindowGroup {
            if ToDo_AppApp.idiom != .pad {
                ContentView()
            } else {
                SplitPadView()
            }
        }
    }
}
