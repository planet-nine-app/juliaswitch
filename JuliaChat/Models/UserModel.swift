//
//  UserModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/12/24.
//

import Foundation
import SwiftData

@Model()
class KeyTuple: Codable {
    var uuid = ""
    var pubKey = ""
    
    init(uuid: String, pubKey: String) {
        self.uuid = uuid
        self.pubKey = pubKey
    }
    
    required init(from decoder: Decoder) throws {
        // what goes here?
    }
    
    func encode(to encoder: Encoder) throws {
        // what goes here?
    }
}

@Model()
class UserKeys: Codable {
    var interactingKeys = [KeyTuple]()
    var coordinatingKeys = [KeyTuple]()
    
    init(interactingKeys: [KeyTuple], coordinatingKeys: [KeyTuple]) {
        self.interactingKeys = interactingKeys
        self.coordinatingKeys = coordinatingKeys
    }
    
    required init(from decoder: Decoder) throws {
        // what goes here?
    }
    
    func encode(to encoder: Encoder) throws {
        // what goes here?
    }
}

@Model()
class User: Codable {
    @Attribute(.unique) var uuid = ""
    var keys = UserKeys(interactingKeys: [], coordinatingKeys: [])
    var messages = [Message]()
    var pubKey = ""
    var handle = ""
    
    enum ConfigKeys: String, CodingKey {
        case uuid
        case keys
        case messages
        case pubKey
        case handle
    }
    
    init(uuid: String = "", keys: UserKeys = UserKeys(interactingKeys: [], coordinatingKeys: []), messages: [Message] = [Message]()) {
        self.uuid = uuid
        self.keys = keys
        self.messages = messages
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.uuid = try values.decodeIfPresent(String.self, forKey: ConfigKeys.uuid)!
        self.keys = try values.decodeIfPresent([UserKeys], forKey: <#T##KeyedDecodingContainer<ConfigKeys>.Key#>)
       
    }
    
    func encode(to encoder: Encoder) throws {
        // what goes here?
    }
}

struct RegisterUser: Codable {
    var timestamp = "".getTime()
    let pubKey: String
    let handle: String
    var signature = ""
    let user: User
    
    init(pubKey: String, handle: String) {
        self.pubKey = pubKey
        self.handle = handle
        
        self.user = User()
        self.user.pubKey = pubKey
        self.user.handle = handle
        
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




