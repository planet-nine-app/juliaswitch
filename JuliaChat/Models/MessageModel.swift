//
//  MessageModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/12/24.
//

import Foundation
import SwiftData

struct PostableMessage: Codable {
    var timestamp: String
    var senderUUID: String
    var receiverUUID: String
    var content: String
    var signature: String
    
    init(timestamp: String, senderUUID: String, receiverUUID: String, content: String) {
        self.timestamp = timestamp
        self.senderUUID = senderUUID
        self.receiverUUID = receiverUUID
        self.content = content
        self.signature = ""
        
        self.signature = self.sign()
    }
    
    func toString() -> String {
        return "\(timestamp)\(senderUUID)\(receiverUUID)\(content)"
    }
    
    func sign() -> String {
        return Sessionless().sign(message: self.toString()) ?? ""
    }
    
    func toData() -> Data? {
        let json = """
            {"timestamp":"\(timestamp)","senderUUID":"\(senderUUID)","receiverUUID":"\(receiverUUID)","message":"\(content)","signature":"\(signature)"}
        """
        
        return json.data(using: .utf8)
    }
}

struct Message: Codable, Identifiable {
    var id: String
    
    var timestamp = ""
    var senderUUID = ""
    var receiverUUID = ""
    var message = ""
    
    enum CodingKeys: String, CodingKey {
            case timestamp
            case senderUUID
            case receiverUUID
            case message
            case id
        }
    
    init(timestamp: String, senderUUID: String, receiverUUID: String, content: String) {
        self.timestamp = timestamp
        self.senderUUID = senderUUID
        self.receiverUUID = receiverUUID
        self.message = content
        self.id = "\(timestamp)\(receiverUUID)\(senderUUID)"
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            timestamp = try container.decode(String.self, forKey: .timestamp)
            senderUUID = try container.decode(String.self, forKey: .senderUUID)
            receiverUUID = try container.decode(String.self, forKey: .receiverUUID)
            message = try container.decode(String.self, forKey: .message)
            id = "\(timestamp)\(receiverUUID)\(senderUUID)"
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(timestamp, forKey: .timestamp)
            try container.encode(senderUUID, forKey: .senderUUID)
            try container.encode(receiverUUID, forKey: .receiverUUID)
            try container.encode(message, forKey: .message)
            try container.encode(id, forKey: .id)
        }
    
}
