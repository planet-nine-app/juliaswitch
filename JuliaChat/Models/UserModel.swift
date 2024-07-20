//
//  UserModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/12/24.
//

import Foundation
import SwiftData

//@Model()
struct KeyTuple: Codable {
    var uuid = ""
    var pubKey = ""
    
    init(uuid: String, pubKey: String) {
        self.uuid = uuid
        self.pubKey = pubKey
    }
    
    enum ConfigKeys: String, CodingKey {
        case uuid
        case pubKey
    }
    
    /*required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.uuid = try values.decode(String.self, forKey: .uuid)
        self.pubKey = try values.decode(String.self, forKey: .pubKey)
    }
    
    func encode(to encoder: Encoder) throws {
        // what goes here?
    }*/
}

//@Model()
struct AssociatedKeys: Codable {
    var interactingKeys = [String: KeyTuple]()
    var coordinatingKeys = [String: KeyTuple]()
    
    init(interactingKeys: [String: KeyTuple], coordinatingKeys: [String: KeyTuple]) {
        self.interactingKeys = interactingKeys
        self.coordinatingKeys = coordinatingKeys
    }
    
    enum ConfigKeys: String, CodingKey {
        case interactingKeys
        case coordinatingKeys
    }
    
    /*required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.interactingKeys = try values.decodeIfPresent([KeyTuple].self, forKey: .interactingKeys)!
        self.coordinatingKeys = try values.decodeIfPresent([KeyTuple].self, forKey: .coordinatingKeys)!
    }
    
    func encode(to encoder: Encoder) throws {
        // what goes here?
    }*/
}

@Model()
class User: Codable {
    @Attribute(.unique) var uuid = ""
    var keys = AssociatedKeys(interactingKeys: [:], coordinatingKeys: [:])
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
    
    init(uuid: String = "", keys: AssociatedKeys = AssociatedKeys(interactingKeys: [:], coordinatingKeys: [:]), messages: [Message] = [Message]()) {
        self.uuid = uuid
        self.keys = keys
        self.messages = messages
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.uuid = try values.decodeIfPresent(String.self, forKey: .uuid)!
        self.keys = try values.decodeIfPresent(AssociatedKeys.self, forKey: .keys)!
        self.messages = try values.decodeIfPresent([Message].self, forKey: .messages)!
        self.pubKey = try values.decode(String.self, forKey: .pubKey)
        self.handle = try values.decode(String.self, forKey: .handle)
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
        self.user.messages = [Message]()
        
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
            {"timestamp":"\(timestamp)","pubKey":"\(pubKey)","handle":"\(handle)","user":{"pubKey":"\(pubKey)","handle":"\(handle)","messages":[]},"signature":"\(signature)"}
        """
        print(signature)
        print(self.toString())
        print(pubKey)
        return json.data(using: .utf8)
    }
}




