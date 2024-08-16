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
    var appPreferences = [String: String]()
    var globalPreferences = [String: String]()
    
    init(appPreferences: [String : String] = [String: String](), globalPreferences: [String : String] = [String: String]()) {
        self.appPreferences = appPreferences
        self.globalPreferences = globalPreferences
    }
    
    enum ConfigKeys: String, CodingKey {
        case appPreferences
        case globalPreferences
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
