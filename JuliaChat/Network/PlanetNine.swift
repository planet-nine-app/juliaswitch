//
//  PlanetNine.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/12/24.
//

import Foundation

public struct GatewayAddition: Codable {
    let timestamp: String
    let gatewayUUID: String
    let gatewayName: String
    let minimumCost: Int
    let ordinal: Int
    var gatewaySignature: String
    let additions: [String]
    
    init(timestamp: String, gatewayUUID: String, gatewayName: String, minimumCost: Int, ordinal: Int, additions: [String]) {
        self.timestamp = timestamp
        self.gatewayUUID = gatewayUUID
        self.gatewayName = gatewayName
        self.minimumCost = minimumCost
        self.ordinal = ordinal
        self.gatewaySignature = ""
        self.additions = additions
        
        self.sign()
    }
    
    func toString() -> String {
        return """
            {"timestamp":"\(timestamp)","gatewayUUID":"\(gatewayUUID)","gatewayName":"\(gatewayName)","minimumCost":\(minimumCost),"ordinal":"\(ordinal)","additions":"\(additions.joined())"}
        """
    }
    
    mutating func sign() {
        let sessionless = Sessionless()
        guard let signature = sessionless.sign(message: self.toString()) else { return }
        self.gatewaySignature = signature
    }
}

public struct GatewayMVP: Codable {
    let timestamp: String
    let uuid: String
    let minimumCost: Int
    let ordinal: Int
    var signature: String
    
    init(timestamp: String, uuid: String, minimumCost: Int, ordinal: Int) {
        self.timestamp = timestamp
        self.uuid = uuid
        self.minimumCost = minimumCost
        self.ordinal = ordinal
        self.signature = ""
        
        self.sign()
    }
    
    func toString() -> String {
        let message = """
        {"timestamp":"\(timestamp)","uuid":"\(uuid)","minimumCost":\(minimumCost),"ordinal":\(ordinal)}
        """
        print("gateway message: \(message)")
        return message
    }
    
    func toSpellString() -> String {
        return """
        {"timestamp":"\(timestamp)","uuid":"\(uuid)","minimumCost":\(minimumCost),"ordinal":\(ordinal),\"signature\":\"\(signature)\"}
        """
    }
    
    mutating func sign() {
        let sessionless = Sessionless()
        guard let signature = sessionless.sign(message: self.toString()) else { return }
        self.signature = signature
    }
}

public struct Spell: Codable {
    var timestamp: String = ""
    var spellName: String = ""
    var casterUUID: String = ""
    var totalCost: Int = 1
    var mp: Bool = false
    var ordinal: Int = 1
    var casterSignature: String = ""
    var gateways: [GatewayMVP] = []
    var additions: [JSON] = []
    
    init() {
        
    }
    
    init(timestamp: String, spellName: String, casterUUID: String, totalCost: Int, mp: Bool, ordinal: Int, casterSignature: String, gateways: [GatewayMVP], additions: [JSON]) {
        self.timestamp = timestamp
        self.spellName = spellName
        self.casterUUID = casterUUID
        self.totalCost = totalCost
        self.mp = mp
        self.ordinal = ordinal
        self.casterSignature = casterSignature
        self.gateways = gateways
        self.additions = additions
        
        self.sign()

    }
    
    init(spellData: Data) {
        var decodedSpell = Spell()
        do {
            decodedSpell = try JSONDecoder().decode(Spell.self, from: spellData)
        } catch {
            print("Error getting gateway")
            print(error)
        }
        self = decodedSpell
    }
    
    public func toString() -> String {
        var gatewaysMapped = gateways.map { gateway in
            return "\(gateway.toSpellString()),"
        }
        var gatewaysAsStrings = gatewaysMapped.joined()
        gatewaysAsStrings.popLast()
        let gatewaysAsStringsArray = "[\(gatewaysAsStrings)]"
        
        var additionsAsStrings = additions.map({ runEncode($0) })
        let additionsAsString = additionsAsStrings.joined(separator: ",")
        let additionsAsStringsArray = "[\(additionsAsString)]"
        
        print(gatewaysAsStringsArray)
        
        let spellString = """
            {"timestamp":"\(timestamp)","spell":"\(spellName)","casterUUID":"\(casterUUID)","totalCost":\(totalCost),"mp":\(1),"ordinal":\(ordinal),"gateways":\(gatewaysAsStringsArray),"additions":"\(additionsAsStringsArray)","casterSignature":"\(casterSignature)"}
        """
        
        print(spellString)
        return spellString
    }
    
    public func toData() -> Data? {
        return self.toString().data(using: .utf8)
    }
    
    public func toMessageString() -> String {
        let spellString = """
        {"timestamp":"\(timestamp)","spell":"\(spellName)","casterUUID":"\(casterUUID)","totalCost":\(totalCost),"mp":\(1),"ordinal":"\(ordinal)"}
        """
        
        return spellString
    }
    
    mutating func sign() {
        let sessionless = Sessionless()
        guard let signature = sessionless.sign(message: self.toMessageString()) else { return }
        self.casterSignature = signature
    }
}

struct Success: Codable {
    var success: Bool
}

class PlanetNine {
    
    class func createUser(uiHandler: @escaping (Error?, PlanetNineUser?) -> Void) async {
        let handler = ResponseHandler.handlerForModel(for: PlanetNineUser.self, completion: uiHandler)
        
        await Network.registerPlanetNineUser(baseURL: ServiceURLs.planetNine.rawValue, callback: handler)
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
