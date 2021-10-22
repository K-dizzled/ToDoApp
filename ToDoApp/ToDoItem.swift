//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by Андрей on 22.10.2021.
//

import Foundation

final class ToDoItem : Equatable {
    let id: String
    private(set) var text: String
    private(set) var importance: Importance
    private(set) var deadline: TimeInterval?
    
    init(itemId id: String? = nil,
         text: String,
         importance: Importance,
         deadline: TimeInterval? = nil) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.importance = importance
        self.deadline = deadline
    }
    
    static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        if(lhs.deadline != rhs.deadline) {
            return false
        }
        if(lhs.text != rhs.text) {
            return false
        }
        if(lhs.id != rhs.id) {
            return false
        }
        if(lhs.importance != rhs.importance) {
            return false
        }
        
        return true
    }
}

extension ToDoItem {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case text = "text"
        case importance = "importance"
        case deadline = "deadline"
    }
    
    enum TODOKeys: String, CodingKey {
           case todoItem = "todoItem"
    }
}

extension ToDoItem : Codable {
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: TODOKeys.self)
        var properties = values.nestedContainer(keyedBy: CodingKeys.self, forKey: .todoItem)
        try properties.encode(id, forKey: .id)
        try properties.encode(text, forKey: .text)
        try properties.encodeIfPresent(deadline, forKey: .deadline)
        if(importance != .ordinary) {
            try properties.encode(importance, forKey: .importance)
        }
    }
    
    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TODOKeys.self)
        let properties = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .todoItem)
        
        let id = try properties.decode(String.self, forKey: .id)
        let text = try properties.decode(String.self, forKey: .text)
        
        var deadline : TimeInterval? = nil
        if let date = try? properties.decode(TimeInterval.self, forKey: .deadline) {
            deadline = date
        }
        
        var importance : Importance = .ordinary
        if let imp = try? properties.decode(Importance.self, forKey: .importance) {
            importance = imp
        }
        
        self.init(itemId: id,
                  text: text,
                  importance: importance,
                  deadline: deadline)
    }
}
