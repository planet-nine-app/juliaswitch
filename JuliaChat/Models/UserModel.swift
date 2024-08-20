//
//  UserModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/12/24.
//

import Foundation
import SwiftData

//@Model()
struct KeyTuple: Identifiable {
    var id: ObjectIdentifier
    
    var uuid = ""
    var pubKey = ""
    let data = Data()
    
    init(uuid: String, pubKey: String) {
        self.uuid = uuid
        self.pubKey = pubKey
        self.id = ObjectIdentifier(KeyTuple.self)
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
    var interactingKeys = [String: String]()
    var coordinatingKeys = [String: String]()
    
    init(interactingKeys: [String: String], coordinatingKeys: [String: String]) {
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
    @Attribute(.unique) var juliaUUID = ""
    var keys = AssociatedKeys(interactingKeys: [:], coordinatingKeys: [:])
    var messages = [Message]()
    var pubKey = ""
    var handle = ""
    var pendingPrompts = [String: Prompt]()
    
    enum ConfigKeys: String, CodingKey {
        case uuid
        case keys
        case messages
        case pubKey
        case handle
        case pendingPrompts
    }
    
    init(uuid: String = "", keys: AssociatedKeys = AssociatedKeys(interactingKeys: [:], coordinatingKeys: [:]), messages: [Message] = [Message]()) {
        self.juliaUUID = uuid
        self.keys = keys
        self.messages = messages
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.juliaUUID = try values.decodeIfPresent(String.self, forKey: .uuid)!
        self.keys = try values.decodeIfPresent(AssociatedKeys.self, forKey: .keys)!
        self.messages = try values.decodeIfPresent([Message].self, forKey: .messages)!
        self.pubKey = try values.decode(String.self, forKey: .pubKey)
        self.handle = try values.decode(String.self, forKey: .handle)
        self.pendingPrompts = try values.decode([String: Prompt].self, forKey: .pendingPrompts)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ConfigKeys.self)
        try container.encode(juliaUUID, forKey: .uuid)
        try container.encode(keys, forKey: .keys)
        try container.encode(messages, forKey: .messages)
        try container.encode(pubKey, forKey: .pubKey)
        try container.encode(handle, forKey: .handle)
        try container.encode(pendingPrompts, forKey: .pendingPrompts)
    }
    
    func promptsAsArray() -> [Prompt] {
        var prompts = [Prompt]()
        for (prompt, pendingPrompt) in self.pendingPrompts {
            print("got prompt: \(prompt)")
            print("and pendingPrompt: \(pendingPrompt)")
            if pendingPrompt.prompt == "no prompt" { // this is temporary. Remove soon
                continue
            }
            prompts.append(pendingPrompt)
        }
        return prompts
    }
    
    func mostRecentPrompt() -> String? {
        let prompts = self.promptsAsArray()
        guard prompts.count > 0 else { return nil }
        return prompts.filter({ $0.newPubKey == nil }).sorted(by: { $0.timestamp > $1.timestamp })[0].prompt
    }
    
    func mostRecentSignedPrompt() -> String? {
        let prompts = self.promptsAsArray()
        guard prompts.count > 0 else { return nil }
        return prompts.filter({ $0.newPubKey != nil }).sorted(by: { $0.timestamp > $1.timestamp })[0].prompt
    }
    
    func connections() -> [KeyTuple] {
        var connections = [KeyTuple]()
        for (key, value) in self.keys.interactingKeys {
            let tuple = KeyTuple(uuid: key, pubKey: value)
            connections.append(tuple)
        }
        return connections
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
            {"timestamp":"\(timestamp)","pubKey":"\(pubKey)","handle":"\(handle)","user":{"pubKey":"\(pubKey)","handle":"\(handle)","messages":[],"pendingPrompts":{}},"signature":"\(signature)"}
        """
        print(signature)
        print(self.toString())
        print(pubKey)
        return json.data(using: .utf8)
    }
}




