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
    var newPubKey: String?
    var newUUID: String?
    var newSignature: String?
    
    enum ConfigKeys: String, CodingKey {
        case timestamp
        case prompter
        case prompt
        case newPubKey
        case newUUID
        case newSignature
    }
    
    init(prompt: String = "") {
        self.prompt = prompt
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)!
        self.prompter = try values.decodeIfPresent(String.self, forKey: .prompter)!
        self.prompt = try values.decodeIfPresent(String.self, forKey: .prompt)
        self.newPubKey = try values.decode(String.self, forKey: .newPubKey)
        self.newUUID = try values.decode(String.self, forKey: .newUUID)
        self.newSignature = try values.decode(String.self, forKey: .newSignature)
    }
    
    func encode(to encoder: Encoder) throws {
        // what goes here?
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
