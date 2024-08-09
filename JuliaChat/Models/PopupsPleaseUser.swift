//
//  PlanetNineUser.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/2/24.
//

import Foundation
import SwiftData

@Model()
class PopupsPleaseUser: Codable {
    @Attribute(.unique) var uuid = ""
    
    var pubKey = ""
    var popupsAdded = [String]()
    var popupsVisited = [String]()
    var rewards = [String: String]()
    
    enum ConfigKeys: String, CodingKey {
        case uuid
        case pubKey
        case popupsAdded
        case popupsVisited
        case rewards
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.uuid = try values.decodeIfPresent(String.self, forKey: .uuid)!
        self.pubKey = try values.decodeIfPresent(String.self, forKey: .pubKey)!
        self.popupsAdded = try values.decodeIfPresent([String].self, forKey: .popupsAdded)!
        self.popupsVisited = try values.decode([String].self, forKey: .popupsVisited)
        self.rewards = try values.decode([String: String].self, forKey: .rewards)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ConfigKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(pubKey, forKey: .pubKey)
        try container.encode(popupsAdded, forKey: .popupsAdded)
        try container.encode(popupsVisited, forKey: .popupsVisited)
        try container.encode(rewards, forKey: .rewards)
    }
}

struct RegisterPopupsPleaseUser: Codable {
    var timestamp = "".getTime()
    let pubKey: String
    var signature = ""
    
    init(pubKey: String) {
        self.pubKey = pubKey
                
        self.signature = self.sign()
    }
    
    func toString() -> String {
        return "\(timestamp)"
    }
    
    func sign() -> String {
        let sessionless = Sessionless()
        return sessionless.sign(message: self.toString()) ?? ""
    }
    
    func toData() -> Data? {
        let json = """
            {"signature": "\(signature)","timestamp":"\(timestamp)","user":{"pubKey":"\(pubKey)","popupsAdded":[],"popupsVisited":[],"rewards":{}}}
        """
        print(signature)
        print(self.toString())
        print(pubKey)
        return json.data(using: .utf8)
    }
}
