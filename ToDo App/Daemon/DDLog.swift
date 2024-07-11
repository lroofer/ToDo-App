//
//  DDLog.swift
//  ToDo App
//
//  Created by Егор Колобаев on 11.07.2024.
//

import Foundation
import CocoaLumberjackSwift

extension ToDo_AppApp {
    func initLogger() {
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours.
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        DDLogDebug("Logger has been activated")
    }
}
