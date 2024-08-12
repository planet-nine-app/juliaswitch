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
    
    class func deleteKey() {
        // TODO
    }
    
    class func deleteUser(uuid: String) {
        
        // TODO
        
    }
}
