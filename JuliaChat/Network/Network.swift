//
//  Network.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/16/24.
//

import Foundation

enum NetworkError: Error {
    case networkError
}

/*enum ServiceURLs: String {
    case julia = "http://localhost:3000"
    case planetNine = "http://localhost:3001"
    case pref = "http://localhost:3002"
    case bdo = "http://localhost:3003"
}*/

enum ServiceURLs: String {
    case julia = "http://192.168.68.111:3000"
    case planetNine = "http://192.168.68.111:3001"
    case pref = "http://192.168.68.111:3002"
    case bdo = "http://192.168.68.111:3003"
}

class Network {
    class func get(urlString: String, callback: @escaping (Error?, Data?) -> Void) async {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode > 300 {
                callback(NetworkError.networkError, nil)
                return
            }
            callback(nil, data)
        } catch {
            callback(error, nil)
        }
    }
    
    class func post(urlString: String, payload: Data, callback: @escaping (Error?, Data?) -> Void) async {
        guard let url = URL(string: urlString) else { return }
        print("postin'")
        print(payload)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: payload)
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode > 300 {
                callback(NetworkError.networkError, nil)
                return
            }
            print("data here is \(data)")
            callback(nil, data)
            
        } catch {
            callback(error, nil)
        }
    }
    
    class func put(urlString: String, payload: Data, callback: @escaping (Error?, Data?) -> Void) async {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: payload)
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode > 300 {
                callback(NetworkError.networkError, nil)
                return
            }
            callback(nil, data)
        } catch {
            callback(error, nil)
        }
    }
    
    class func delete(urlString: String, payload: Data, callback: @escaping (Error?, Data?) -> Void) async {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: payload)
            callback(nil, data)
        } catch {
            callback(error, nil)
        }
    }
    
    class func registerJulia(baseURL: String, handle: String, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let keys = sessionless.generateKeys()
        
        guard let publicKey = keys?.publicKey,
              let payload = RegisterUser(pubKey: publicKey, handle: handle).toData() else { return }
        
        await Network.put(urlString: "\(baseURL)/user/create", payload: payload) { err, data in
            callback(err, data)
        }
    }
    
    class func registerPlanetNineUser(baseURL: String, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let keys = sessionless.getKeys() 
        
        guard let publicKey = keys?.publicKey,
        let payload = RegisterPlanetNineUser(pubKey: publicKey).toData() else { return }
        
        await Network.put(urlString: "\(baseURL)/user/create", payload: payload) { err, data in
            callback(err, data)
        }
    }
    
    class func registerPref(baseURL: String, preferences: [String: String], callback: @escaping (Error?, Data?) -> Void) async {
        guard let payload = RegisterPreferences.payload(preferences: preferences) else { return }
        
        await Network.put(urlString: "\(baseURL)/user/create", payload: payload) { err, data in
            callback(err, data)
        }
    }
    
    class func registerBDO(baseURL: String, bdo: [String: JSON]?, callback: @escaping (Error?, Data?) -> Void) async {
        
        guard let payload = RegisterBDO.payload(bdo: bdo) else { return }
        
        await Network.put(urlString: "\(baseURL)/user/create", payload: payload) { err, data in
            callback(err, data)
        }
    }
    
    class func getUser(baseURL: String, user: User, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let timestamp = "".getTime()
        let signature = sessionless.sign(message: "\(timestamp)\(user.juliaUUID)") ?? ""
        
        await Network.get(urlString: "\(baseURL)/user/\(user.juliaUUID)?timestamp=\(timestamp)&signature=\(signature)", callback: callback)
    }
    
    class func getPrompt(baseURL: String, user: User, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let timestamp = "".getTime()
        let message = "\(timestamp)\(user.juliaUUID)"
        let signature = sessionless.sign(message: message) ?? ""
        await Network.get(urlString: "\(baseURL)/user/\(user.juliaUUID)/associate/prompt?timestamp=\(timestamp)&signature=\(signature)", callback: {err, data in
            callback(err, data)
        })
    }
    
    class func postPrompt(baseURL: String, user: User, prompt: String, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        
        guard let publicKey = sessionless.getKeys()?.publicKey,
              let payload = PostPrompt(timestamp: "".getTime(), uuid: user.juliaUUID, pubKey: publicKey, prompt: prompt).toData() else { return }
        
        await Network.post(urlString: "\(baseURL)/user/\(user.juliaUUID)/associate/signedPrompt", payload: payload, callback: {err, data in
            callback(err, data)
        })
    }
    
    class func associate(baseURL: String, user: User, signedPrompt: PostPrompt, callback: @escaping (Error?, Data?) -> Void) async {
        let timestamp = "".getTime()
        
        guard let payload = PostAssociate(timestamp: timestamp, newTimestamp: signedPrompt.timestamp, newUUID: signedPrompt.uuid, newPubKey: signedPrompt.pubKey, prompt: signedPrompt.prompt, newSignature: signedPrompt.signature, signature: "").toData() else { return }
        
        await Network.post(urlString: "\(baseURL)/user/\(user.juliaUUID)/associate", payload: payload, callback: callback)
    }
    
    class func disassociate(baseURL: String, user: User, keyToDisassociate: KeyTuple, callback: @escaping (Error?, Data?) -> Void) async {
        
        guard let payload = Disassociate(associatedUUID: keyToDisassociate.uuid, uuid: user.juliaUUID).toData() else { return }
        
        await Network.delete(urlString: "\(baseURL)/associated/\(keyToDisassociate.uuid)/user/\(user.juliaUUID)", payload: payload, callback: callback)
    }
    
    class func deleteJuliaUser(baseURL: String, user: User, callback: @escaping (Error?, Data?) -> Void) async {
        guard let payload = DeleteJuliaUser(uuid: user.juliaUUID).toData() else { return }
        
        await Network.delete(urlString: "\(baseURL)/user/\(user.juliaUUID)", payload: payload, callback: callback)
    }
    
    class func sendMessage(baseURL: String, user: User, content: String, receiverUUID: String, callback: @escaping (Error?, Data?) -> Void) async {
        
        guard let payload = PostableMessage(timestamp: "".getTime(), senderUUID: user.juliaUUID, receiverUUID: receiverUUID, content: content).toData() else { return }
        
        await Network.post(urlString: "\(baseURL)/message", payload: payload, callback: callback)
    }
    
    class func getMessages(baseURL: String, user: User, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let timestamp = "".getTime()
        let message = "\(timestamp)\(user.juliaUUID)"
        guard let signature = sessionless.sign(message: message) else { return }
        
        await Network.get(urlString: "\(baseURL)/messages/user/\(user.juliaUUID)?timestamp=\(timestamp)&signature=\(signature)", callback: callback)
    }
    
    class func putPreferences(baseURL: String, prefUser: PrefUser, newPreferences: [String: String], callback: @escaping (Error?, Data?) -> Void) async {
        let timestamp = "".getTime()
        
        guard let payload = PostablePreferences(timestamp: timestamp, prefUUID: prefUser.uuid, preferences: newPreferences).toData() else { return }
                
        await Network.put(urlString: baseURL, payload: payload, callback: callback)
    }
}

extension String {
    func getTime() -> String {
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: dateFormatter.string(from: currentDate as Date))
        let nowDouble = date!.timeIntervalSince1970
        return String(Int(nowDouble * 1000.0))
    }
}
