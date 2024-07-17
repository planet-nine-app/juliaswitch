//
//  PromptModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/16/24.
//

import Foundation
import SwiftData

@Model
class Prompt {
    var prompt = ""
    
    init(prompt: String = "") {
        self.prompt = prompt
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
        return "\(timestamp)\(uuid)\(pubKey)\(prompt)"
    }
    
    func sign() -> String {
        let sessionless = Sessionless()
        return sessionless.sign(message: self.toString()) ?? ""
    }
    
    func toData() -> Data? {
        let json = """
            {"timestamp":"\(timestamp)","uuid":"\(uuid)","pubKey":"\(pubKey)","prompt":"\(prompt)"}
        """
        
        return json.data(using: .utf8)
    }
}
