//
//  Pref.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/12/24.
//

import Foundation

struct PrefUser: Codable {
    var uuid = ""
    var preferences = [String: String]()
}

class Pref {
    
    class func createUser(preferences: [String: String], uiHandler: @escaping (Error?, 
PrefUser?) -> Void) async {
        let handler = ResponseHandler.handlerForModel(for: PrefUser.self, completion: uiHandler)
        
        await Network.registerPref(baseURL: ServiceURLs.pref.rawValue, preferences: preferences, callback: handler)
    }
    
    class func savePreferences(prefUser: PrefUser, newPreferences: [String: String], uiHandler: @escaping (Error?, [String: String]?) -> Void) async {
        let handler = ResponseHandler.handlerForModel(for: PrefUser.self, completion: uiHandler)
        
        await Network.putPreferences(prefUser: prefUser, newPreferences, handler)
    }
    
    class func saveGlobalPreferences(prefUser: PrefUser, newPreferences: [String: String], uiHandler: @escaping (Error?, [String: String]?) -> Void) {
        // TODO
    }
    
    class func getPreferences(prefUser: PrefUser, hash: String, uiHandler: @escaping (Error?, [String: String]?) -> Void) {
        // TODO
    }
    
    class func getGlobalPreferences(prefUser: PrefUser, uiHandler: @escaping (Error?, [String: String]?) -> Void) {
        // TODO
    }
    
    class func deleteUser(prefUser: PrefUser, uiHandler: @escaping (Error?, Success?) -> Void) {
        // TODO
    }
}
