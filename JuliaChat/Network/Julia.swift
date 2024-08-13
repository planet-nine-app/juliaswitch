//
//  Julia.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/12/24.
//

import Foundation
import SwiftData

class Julia {
    
    class func checkForUser() {
        fatalError("unimplemented")
    }
    
    class func createUser(handle: String, uiHandler: @escaping (Error?, User?) -> Void) async {
        let handler = ResponseHandler.handlerForModel(for: User.self, completion: uiHandler)
        
        await Network.register(baseURL: ServiceURLs.julia.rawValue, handle: handle, callback: handler)
    }
    
    class func syncKeys(user: User, uiHandler: @escaping (Error?, User?) -> Void) async {
        let handler = ResponseHandler.handlerForModel(for: User.self, completion: uiHandler)
        
        await Network.getUser(baseURL: ServiceURLs.julia.rawValue, user: user, callback: handler)
    }
    
    class func associate(user: User, signedPrompt: PostPrompt, uiHandler: @escaping (Error?, User?) -> Void) async {
        let handler = ResponseHandler.handlerForModel(for: User.self, completion: uiHandler)
        
        await Network.associate(baseURL: ServiceURLs.julia.rawValue, user: user, signedPrompt: signedPrompt, callback: handler)
    }
    
    class func getPrompt(user: User, uiHandler: @escaping (Error?, User?) -> Void) async {
        let handler = ResponseHandler.handlerForModel(for: User.self, completion: uiHandler)
        
        await Network.getPrompt(baseURL: ServiceURLs.julia.rawValue, user: user, callback: handler)
    }
    
    class func postPrompt(user: User, prompt: String, uiHandler: @escaping (Error?, Success?) -> Void) async {
        let handler = ResponseHandler.handlerForModel(for: Success.self, completion: uiHandler)
        
        await Network.postPrompt(baseURL: ServiceURLs.julia.rawValue, user: user, prompt: prompt, callback: handler)
    }
    
    class func deleteKey() {
        // TODO
    }
    
    class func deleteUser(uuid: String) {
        
        // TODO
        
    }
}
