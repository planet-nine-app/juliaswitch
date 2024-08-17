//
//  PreferencesModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/13/24.
//

import Foundation
import SwiftData

@Model()
class Preferences {
    var prefUUID = ""
    var appPreferences = [String: String]()
    var globalPreferences = [String: String]()
    
    init(appPreferences: [String : String] = [String: String](), globalPreferences: [String : String] = [String: String]()) {
        self.appPreferences = appPreferences
        self.globalPreferences = globalPreferences
    }
    
    enum ConfigKeys: String, CodingKey {
        case prefUUID
        case appPreferences
        case globalPreferences
    }
}

struct PostablePreferences {
    let timestamp: String
    let prefUUID: String
    let hash = "thisisthehashwe'llusefornow"
    let preferences: [String: String]
    var signature = ""
    
    init(timestamp: String, prefUUID: String, preferences: [String : String], signature: String = "") {
        self.timestamp = timestamp
        self.prefUUID = prefUUID
        self.preferences = preferences
        
        self.signature = self.sign()
    }
    
    
    func toString() -> String {
        return "\(timestamp)\(prefUUID)\(hash)"
    }
    
    func sign() -> String {
        let sessionless = Sessionless()
        return sessionless.sign(message: self.toString()) ?? ""
    }
    
    func toData() -> Data? {
        var preferencesJSON = "{"
        for (k, v) in preferences {
            preferencesJSON = "\(preferencesJSON)\"\(k)\":\"\(v)\","
        }
        let _ = preferencesJSON.popLast()
        preferencesJSON = "\(preferencesJSON)}"
        
        let json = """
            {"timestamp":"\(timestamp)","hash":"\(hash)","signature":"\(signature)","preferences":\(preferencesJSON)}
        """
        
        return json.data(using: .utf8)
    }
    
}

class RegisterPreferences {
    class func payload(preferences: [String: String]) -> Data? {
        let sessionless = Sessionless()
        guard let pubKey = sessionless.getKeys() else { return nil }
        
        let timestamp = "".getTime()
        let hash = "thisisthehashwe'llusefornow"
        let message = "\(timestamp)\(pubKey)\(hash)"
        let signature = sessionless.sign(message: message) ?? ""
        
        var preferencesJSON = "{"
        for (k, v) in preferences {
            preferencesJSON = "\(preferencesJSON)\"\(k)\":\"\(v)\","
        }
        let _ = preferencesJSON.popLast()
        preferencesJSON = "\(preferencesJSON)}"
        
        let json = """
            {"timestamp":"\(timestamp)","pubKey":"\(pubKey)","hash":"\(hash)","signature":"\(signature)","preferences":\(preferencesJSON)}
        """
        
        return json.data(using: .utf8)
    }
}
