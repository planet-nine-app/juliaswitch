//
//  BDOModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/16/24.
//

import Foundation
import SwiftData

@Model()
class BDOModel {
    var bdoUUID = ""
    var bdo: JSON?
    
    init(bdoUUID: String, bdo: JSON?) {
        self.bdoUUID = bdoUUID
        self.bdo = bdo
    }
    
    enum ConfigKeys: String, CodingKey {
        case bdoUUID
        case bdo
    }
}

struct PostableBDO {
    let timestamp: String
    let bdoUUID: String
    let hash = "thisisthehashwe'llusefornow"
    let bdo: JSON
    var signature = ""
    
    init(timestamp: String, bdoUUID: String, bdo: JSON, signature: String = "") {
        self.timestamp = timestamp
        self.bdoUUID = bdoUUID
        self.bdo = bdo
        
        self.signature = self.sign()
    }
    
    
    func toString() -> String {
        return "\(timestamp)\(bdoUUID)\(hash)"
    }
    
    func sign() -> String {
        let sessionless = Sessionless()
        return sessionless.sign(message: self.toString()) ?? ""
    }
    
    
    func toData() -> Data? {
        let bdoJSON = runEncode(bdo)
        
        let json = """
            {"timestamp":"\(timestamp)","hash":"\(hash)","signature":"\(signature)","bdo":\(bdoJSON)}
        """
        
        return json.data(using: .utf8)
    }
    
}

class RegisterBDO {
    class func payload(preferences: [String: String]) -> Data? {
        let sessionless = Sessionless()
        guard let pubKey = sessionless.getKeys() else { return nil }
        
        let timestamp = "".getTime()
        let hash = "thisisthehashwe'llusefornow"
        let message = "\(timestamp)\(pubKey)\(hash)"
        let signature = sessionless.sign(message: message) ?? ""
        
        // Registering can have a BDO, but I'm leaving that out here for now.
        
        let json = """
            {"timestamp":"\(timestamp)","pubKey":"\(pubKey)","hash":"\(hash)","signature":"\(signature)"}
        """
        
        return json.data(using: .utf8)
    }
}
