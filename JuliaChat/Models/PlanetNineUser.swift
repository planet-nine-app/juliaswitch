//
//  PlanetNineUser.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/2/24.
//

import Foundation
import SwiftData

struct PaymentMethod: Codable {
    var cardId: String
    var brand: String
    var lastFour: String
}

@Model()
class PlanetNineUser: Codable {
    @Attribute(.unique) var planetNineUUID = ""
    
    var pubKey = ""
    var handle = ""
    var paymentMethods = [PaymentMethod]()
    var mp = 0
    var maxMP = 0
    var experience = 0
    var lastExperienceCalculated = "".getTime()
    var experiencePool = 0
    
    enum ConfigKeys: String, CodingKey {
        case uuid
        case pubKey
        case paymentMethods
        case mp
        case maxMP
        case experience
        case lastExperienceCalculated
        case experiencePool
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.planetNineUUID = try values.decodeIfPresent(String.self, forKey: .uuid)!
        self.pubKey = try values.decodeIfPresent(String.self, forKey: .pubKey)!
        self.paymentMethods = try values.decodeIfPresent([PaymentMethod].self, forKey: .paymentMethods)!
        self.mp = try values.decode(Int.self, forKey: .mp)
        self.maxMP = try values.decode(Int.self, forKey: .maxMP)
        self.experience = try values.decode(Int.self, forKey: .experience)
        self.lastExperienceCalculated = try values.decode(String.self, forKey: .lastExperienceCalculated)
        self.experiencePool = try values.decode(Int.self, forKey: .experiencePool)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ConfigKeys.self)
        try container.encode(planetNineUUID, forKey: .uuid)
        try container.encode(pubKey, forKey: .pubKey)
        try container.encode(paymentMethods, forKey: .paymentMethods)
        try container.encode(mp, forKey: .mp)
        try container.encode(maxMP, forKey: .maxMP)
        try container.encode(experience, forKey: .experience)
        try container.encode(lastExperienceCalculated, forKey: .lastExperienceCalculated)
        try container.encode(experiencePool, forKey: .experiencePool)
    }
    
    
}

struct RegisterPlanetNineUser: Codable {
    var timestamp = "".getTime()
    let pubKey: String
    var paymentMethods = [PaymentMethod]()
    var signature = ""
    
    init(pubKey: String) {
        self.pubKey = pubKey
                
        self.signature = self.sign()
    }
    
    func toString() -> String {
        return "\(timestamp)\(pubKey)"
    }
    
    func sign() -> String {
        let sessionless = Sessionless()
        return sessionless.sign(message: self.toString()) ?? ""
    }
    
    func toData() -> Data? {
        let json = """
            {"timestamp":"\(timestamp)","pubKey":"\(pubKey)","user":{"pubKey":"\(pubKey)","paymentMethods":[]},"signature":"\(signature)"}
        """
        print(signature)
        print(self.toString())
        print(pubKey)
        return json.data(using: .utf8)
    }
}
