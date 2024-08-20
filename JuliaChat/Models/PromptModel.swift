//
//  PromptModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/16/24.
//

import Foundation
import SwiftData

@Model
class Prompt: Codable {
    var timestamp: String = ""
    var prompter: String = ""
    var prompt: String?
    var newTimestamp: String?
    var newPubKey: String?
    var newUUID: String?
    var newSignature: String?
    
    enum ConfigKeys: String, CodingKey {
        case timestamp
        case prompter
        case newTimestamp
        case newUUID
        case newPubKey
        case prompt
        case newSignature
    }
    
    init(prompt: String = "") {
        self.prompt = prompt
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        print("trying to init prompt: \(values)")
        self.timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? "no timestamp"
        print(self.timestamp)
        self.prompter = try values.decodeIfPresent(String.self, forKey: .prompter) ?? "no prompter"
        self.prompt = try values.decodeIfPresent(String.self, forKey: .prompt) ?? "no prompt"
        self.newTimestamp = try? values.decodeIfPresent(String.self, forKey: .newTimestamp)
        self.newPubKey = try? values.decode(String.self, forKey: .newPubKey)
        self.newUUID = try? values.decode(String.self, forKey: .newUUID)
        self.newSignature = try? values.decode(String.self, forKey: .newSignature)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ConfigKeys.self)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(prompter, forKey: .prompter)
        try container.encodeIfPresent(prompt, forKey: .prompt)
        try container.encodeIfPresent(newTimestamp, forKey: .newTimestamp)
        try container.encodeIfPresent(newPubKey, forKey: .newPubKey)
        try container.encodeIfPresent(newUUID, forKey: .newUUID)
        try container.encodeIfPresent(newSignature, forKey: .newSignature)
    }
    
    func toString() -> String {
        return """
        "{"timestamp":"\(timestamp)","prompter":"\(prompter)","prompt":"\(prompt)","newPubKey":"\(newPubKey)","newUUID":"\(newUUID)","newSignature":"\(newSignature)"}"
        """
    }
}

struct PostPrompt {
    var timestamp = "".getTime()
    var uuid = ""
    var pubKey = ""
    var prompt = ""
    var signature = ""
    
    init(timestamp: String = "".getTime(), uuid: String = "", pubKey: String = "", prompt: String = "", signature: String = "") {
        self.timestamp = timestamp
        self.uuid = uuid
        self.pubKey = pubKey
        self.prompt = prompt
        
        self.signature = self.sign()
    }
    
    func toString() -> String {
        print("\(timestamp)\(uuid)\(pubKey)\(prompt)")
        return "\(timestamp)\(uuid)\(pubKey)\(prompt)"
    }
    
    func sign() -> String {
        let sessionless = Sessionless()
        return sessionless.sign(message: self.toString()) ?? ""
    }
    
    func toData() -> Data? {
        let json = """
            {"timestamp":"\(timestamp)","uuid":"\(uuid)","pubKey":"\(pubKey)","prompt":"\(prompt)","signature":"\(signature)"}
        """
        print(json)
        print(json.count)
        
        return json.data(using: .utf8)
    }
}
