//
//  UserModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/12/24.
//

import Foundation
import SwiftData

@Model()
class KeyTuple {
    var uuid: String
    var pubKey: String
    
    init(uuid: String, pubKey: String) {
        self.uuid = uuid
        self.pubKey = pubKey
    }
}

@Model()
class UserKeys {
    var interactingKeys: [KeyTuple]
    var coordinatingKeys: [KeyTuple]
    
    init(interactingKeys: [KeyTuple], coordinatingKeys: [KeyTuple]) {
        self.interactingKeys = interactingKeys
        self.coordinatingKeys = coordinatingKeys
    }
}

@Model()
class User {
    @Attribute(.unique) var uuid = ""
    var keys = [UserKeys]()
    var messages = [Message]()
    var handle = ""
    
    init(uuid: String = "", keys: [UserKeys] = [UserKeys](), messages: [Message] = [Message]()) {
        self.uuid = uuid
        self.keys = keys
        self.messages = messages
    }
}

struct RegisterUser: Codable {
    var timestamp = "".getTime()
    let pubKey: String
    let handle: String
    var signature = ""
    
    init(pubKey: String, handle: String) {
        self.pubKey = pubKey
        self.handle = handle
        
        self.signature = self.sign()
    }
    
    func toString() -> String {
        return "\(timestamp)\(pubKey)"
    }
    
    func sign() -> String {
        let sessionless = Sessionless()
        return sessionless.sign(message: self.toString()) ?? ""
    }
    
    func toData() -> Data? {
        let json = """
            {"timestamp":"\(timestamp)","pubKey":"\(pubKey)","handle":"\(handle)","signature":"\(signature)"}
        """
        return json.data(using: .utf8)
    }
}



