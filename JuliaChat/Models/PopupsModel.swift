//
//  MessageModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/12/24.
//

import Foundation
import SwiftData

struct Popups: Codable {
    var popups = [Popup]()
    
    enum CodingKeys: String, CodingKey {
        case popups
    }
    
    init(popups: [Popup]) {
        self.popups = popups
    }
}

struct Popup: Codable, Identifiable {
    var id: String
    
    var name = ""
    var dateTimes = [[String: Int]]()
    var location = ""
    var description = ""
    var imageId = ""
    
    enum CodingKeys: String, CodingKey {
            case name
            case dateTimes
            case location
            case description
            case imageId
            case id
    }
    
    init(name: String, dateTimes: [[String: Int]], location: String, description: String, imageId: String) {
        self.name = name
        self.dateTimes = dateTimes
        self.location = location
        self.description = description
        self.imageId = imageId
        self.id = imageId
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            dateTimes = try container.decode([[String: Int]].self, forKey: .dateTimes)
            location = try container.decode(String.self, forKey: .location)
            description = try container.decode(String.self, forKey: .description)
            imageId = try container.decode(String.self, forKey: .imageId)
            id = imageId
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(dateTimes, forKey: .dateTimes)
            try container.encode(location, forKey: .location)
            try container.encode(description, forKey: .description)
            try container.encode(imageId, forKey: .imageId)
            try container.encode(id, forKey: .id)
        }
    
}
