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
PrefUser?) -> Void) {
        let handler = ResponseHandler.handlerForModel(for: PrefUser.self, completion: uiHandler)
        
        // TODO add to network
        //await Network.registerWithPref(baseURL: ServiceURLs.pref.rawValue, preferences, callback: handler)
    }
    
    class func savePreferences(prefUser: PrefUser, hash: String, newPreferences: [String: String], uiHandler: @escaping (Error?, [String: String]?) -> Void) {
        // TODO
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
