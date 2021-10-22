//
//  FileCache.swift
//  ToDoApp
//
//  Created by Андрей on 22.10.2021.
//

import Foundation

class FileCache {
    private(set) var tdList : [ToDoItem]
    
    func addNewTD(_ newTD: ToDoItem) {
        self.tdList.append(newTD)
    }
    
    enum BadIDError: Error {
        case runtimeError(String)
    }
    
    enum BadTDError: Error {
        case runtimeError(String)
    }
    
    enum BadFileError: Error {
        case runtimeError(String)
    }
    
    func deleteTD(_ id: String) throws {
        var flag : Bool = false
        for i in 0..<tdList.count {
            if(tdList[i].id == id) {
                tdList.remove(at: i)
                flag = true
            }
        }
        if(!flag) {
            throw BadIDError.runtimeError("Invalid remove id.")
        }
    }
    
    func loadFromFile(_ fileName: String) throws {
        guard let path : URL = URL(string: fileName) else {
            throw BadFileError.runtimeError("Error with given file.")
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            if let todos = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String] {
                for td in todos {
                    if let decoded = try? decoder.decode(ToDoItem.self, from: td.data(using: .utf8)!) {
                        tdList.append(decoded)
                    }
                }
            }
        } catch {
            throw BadTDError.runtimeError("Error deserializing ToDoItem.")
        }
    }
    
    func loadFromFiles(_ files: [String]) throws {
        for file in files {
            do {
                try self.loadFromFile(file)
            } catch {
                throw BadTDError.runtimeError("Error deserializing ToDoItem from file \(file).")
            }
        }
    }
    
    func saveToFile(_ fileName: String) throws {
        guard let path : URL = URL(string: fileName) else {
            throw BadFileError.runtimeError("Error with given file.")
        }
        
        var buffer : [String] = []
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        for td in tdList {
            if let jsonData = try? encoder.encode(td) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    buffer.append(jsonString)
                }
            } else {
                throw BadTDError.runtimeError("Error serializing ToDoItem.")
            }
        }

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: buffer, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            throw BadTDError.runtimeError("Error serializing ToDoItem.")
        }
    }
    
    init() {
        tdList = []
    }
}
