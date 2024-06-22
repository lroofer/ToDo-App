//
//  CsvParsing.swift
//  ToDo App
//
//  Created by Егор Колобаев on 21.06.2024.
//

import Foundation

extension TodoItem {
    enum CSVParsingError: Error {
        case cannotReadCsvFile
        case incorrectSignatureIn(row: Int)
        case wrongPropertyIn(row: Int, propertyName: String)
    }
    
    private static func parseDateFrom(string: String, indexOfRow index: Int, propertyName: String) throws -> Date? {
        if string == "" {
            return nil
        }
        guard let date = Date.getDate(fromStringLocale: string) else {
            throw CSVParsingError.wrongPropertyIn(row: index, propertyName: propertyName)
        }
        return date
    }
    
    private static func parseBoolFrom(string: String, indexOfRow index: Int, propertyName: String) throws -> Bool {
        if let boolValue = Bool.getBool(fromString: string) {
            return boolValue
        }
        throw CSVParsingError.wrongPropertyIn(row: index, propertyName: propertyName)
        
    }
    
    static func getSetOfItemsFrom(csvFile url: URL, linesOfHeader: Int = 0) throws -> Set<TodoItem> {
        guard let csvFile = try? String(contentsOf: url, encoding: .utf8) else {
            throw CSVParsingError.cannotReadCsvFile
        }
        var items = Set<TodoItem>()
        for (indexOfRow, row) in csvFile.split(whereSeparator: \.isNewline).enumerated() {
            if indexOfRow < linesOfHeader {
                continue
            }
            var values = [String]()
            var areQuotesOpen = false
            var currentValue = ""
            for char in row {
                if char == "," && !areQuotesOpen {
                    values.append(currentValue)
                    currentValue = ""
                } else {
                    if char == "\"" {
                        areQuotesOpen.toggle()
                        continue
                    }
                    currentValue.append(char)
                }
            }
            values.append(currentValue)
            if values.count != 7 {
                throw CSVParsingError.incorrectSignatureIn(row: indexOfRow)
            }
            guard let priority = PriorityChoices.getPriorityFrom(string: values[2]) else {
                throw CSVParsingError.wrongPropertyIn(row: indexOfRow, propertyName: "priority")
            }
            
            
            items.insert(TodoItem(id: values[0].isEmpty ? nil : values[0], text: values[1], priority: priority, deadline: try parseDateFrom(string: values[3], indexOfRow: indexOfRow, propertyName: "deadline"), completed: try parseBoolFrom(string: values[4], indexOfRow: indexOfRow, propertyName: "completed"), creationDate: try parseDateFrom(string: values[5], indexOfRow: indexOfRow, propertyName: "creationDate") ?? Date.now, lastChangeDate: try parseDateFrom(string: values[6], indexOfRow: indexOfRow, propertyName: "lastChangeDate")))
        }
        return items
    }
}
