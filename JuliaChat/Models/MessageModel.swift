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
            {"timestamp":"\(timestamp)","senderUUID":"\(senderUUID)","receiverUUID":"\(receiverUUID)","content":"\(content)","signature":"\(signature)"}
        """
        
        return json.data(using: .utf8)
    }
}

@Model()
class Message {
    var timestamp: String
    var senderUUID: String
    var receiverUUID: String
    var content: String
    
    init(timestamp: String, senderUUID: String, receiverUUID: String, content: String) {
        self.timestamp = timestamp
        self.senderUUID = senderUUID
        self.receiverUUID = receiverUUID
        self.content = content
    }
}
