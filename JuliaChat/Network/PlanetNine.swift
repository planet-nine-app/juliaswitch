//
//  PlanetNine.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/12/24.
//

import Foundation

struct Spell {
    // TODO
}

struct Success: Codable {
    var success: Bool
}

class PlanetNine {
    
    class func createUser(uiHandler: @escaping (Error?, PlanetNineUser?) -> Void) async {
        let handler = ResponseHandler.handlerForModel(for: PlanetNineUser.self, completion: uiHandler)
        
        await Network.register(baseURL: ServiceURLs.planetNine.rawValue, handle: handle, callback: handler)
    }
    
    class func getPlanetNineUser(planetNineUser: PlanetNineUser, uiHandler: @escaping (Error?, PlanetNineUser?) -> Void) async {
        let handler = ResponseHandler.handlerForModel(for: PlanetNineUser.self, completion: uiHandler)

        // TODO add to Network
    }
    
    class func resolve(spell: Spell, uiHandler: @escaping (Error?, Success?) -> Void) async {
        // TODO
    }
    
    class func transfer(planetNineUser: PlanetNineUser, nineum: [String], uiHandler: @escaping (Error?, PlanetNineUser?) -> Void) async {
        // TODO
    }
    
    class func grant(planetNineUser: PlanetNineUser, amount: Int, uiHandler: @escaping (Error?, PlanetNineUser?) -> Void) {
        // TODO
    }
}
