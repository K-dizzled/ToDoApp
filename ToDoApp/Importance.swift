//
//  Importance.swift
//  ToDoApp
//
//  Created by Андрей on 22.10.2021.
//

import Foundation

enum Importance : String {
    case high = "high"
    case ordinary = "ordinary"
    case low = "low"
}

extension Importance {
    enum CodingKeys: CodingKey {
            case high, ordinary, low
    }
}

extension Importance : Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
            case .high:
                try container.encode(true, forKey: .high)
            case .low:
                try container.encode(true, forKey: .low)
            case .ordinary:
                return
        }
    }
    
    init(from decoder: Decoder) throws {
        let labels = try decoder.container(keyedBy: CodingKeys.self)
        let label = labels.allKeys.first
        switch label {
            case .high: self = .high
            case .low: self = .low
            default: self = .ordinary
        }
    }
}
