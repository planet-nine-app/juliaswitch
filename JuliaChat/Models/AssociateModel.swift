//
//  AssociateModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/17/24.
//

import Foundation

struct PostAssociate {
    var timestamp: String
    var newTimestamp: String
    var newUUID: String
    var newPubKey: String
    var prompt: String
    var newSignature: String
    var signature: String
    
    init(timestamp: String, newTimestamp: String, newUUID: String, newPubKey: String, prompt: String, newSignature: String, signature: String) {
        self.timestamp = timestamp
        self.newTimestamp = newTimestamp
        self.newUUID = newUUID
        self.newPubKey = newPubKey
        self.prompt = prompt
        self.newSignature = newSignature
        self.signature = ""
        
        self.signature = self.sign()
    }
    
    func toString() -> String {
        return "\(newTimestamp)\(newUUID)\(newPubKey)\(prompt)"
    }
    
    func sign() -> String {
        let sessionless = Sessionless()
        return sessionless.sign(message: self.toString()) ?? ""
    }
    
    func toData() -> Data? {
        let json = """
            {"timestamp":"\(timestamp)","newTimestamp":"\(newTimestamp)","newUUID":"\(newUUID)","newPubKey":"\(newPubKey)","prompt":"\(prompt)","newSignature":"\(newSignature)","signature":"\(signature)"}
        """
        
        return json.data(using: .utf8)
    }
}
