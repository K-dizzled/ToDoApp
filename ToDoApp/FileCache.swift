//
//  FileCache.swift
//  ToDoApp
//
//  Created by Андрей on 22.10.2021.
//

import Foundation

class FileCache {
    private(set) var toDoList : [ToDoItem]
    
    enum FileCacheError: Error {
        case error
        case dublicateTdError(String)
        case badIdError(String)
        case badTdError(String)
        case badFileError(String)
    }
    
    func addNewTD(_ newTD: ToDoItem) throws {
        if self.toDoList.firstIndex(where: { $0.id == newTD.id }) == nil {
            self.toDoList.append(newTD)
        } else {
            throw FileCacheError.dublicateTdError("To-do with such id is already present in the list.")
        }
    }
    
    func count() -> Int {
        return toDoList.count
    }
    
    func deleteTD(_ id: String) throws {
        if let i = toDoList.firstIndex(where: { $0.id == id }) {
            toDoList.remove(at: i)
        }
    }
    
    func loadFromFile(_ fileName: String) throws {
        guard let path : URL = URL(string: fileName) else {
            throw FileCacheError.badFileError("Error with given file.")
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            if let todos = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String] {
                for td in todos {
                    if let decoded = try? decoder.decode(ToDoItem.self, from: td.data(using: .utf8)!) {
                        toDoList.append(decoded)
                    } else {
                        throw FileCacheError.error
                    }
                }
            }
        } catch {
            throw FileCacheError.badTdError("Error deserializing ToDoItem.")
        }
    }
    
    func loadFromFiles(_ files: [String]) throws {
        for file in files {
            do {
                try self.loadFromFile(file)
            } catch {
                throw FileCacheError.badTdError("Error deserializing ToDoItem from file \(file).")
            }
        }
    }
    
    func saveToFile(_ fileName: String) throws {
        guard let path : URL = URL(string: fileName) else {
            throw FileCacheError.badFileError("Error with given file.")
        }
        
        var buffer : [String] = []
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        for td in toDoList {
            if let jsonData = try? encoder.encode(td) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    buffer.append(jsonString)
                }
            } else {
                throw FileCacheError.badTdError("Error serializing ToDoItem.")
            }
        }

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: buffer, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            throw FileCacheError.badTdError("Error serializing ToDoItem.")
        }
    }
    
    init() {
        toDoList = []
    }
}
