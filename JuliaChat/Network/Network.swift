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
    
    class func register(baseURL: String, handle: String, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let keys = sessionless.generateKeys()
        
        guard let publicKey = keys?.publicKey,
              let payload = RegisterUser(pubKey: publicKey, handle: handle).toData() else { return }
        
        await Network.put(urlString: "\(baseURL)/user/create", payload: payload) { err, data in
            callback(err, data)
        }
    }
    
    class func registerPlanetNineUser(baseURL: String, handle: String, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let keys = sessionless.getKeys() 
        
        guard let publicKey = keys?.publicKey,
        let payload = RegisterPlanetNineUser(pubKey: publicKey, handle: "TEST USER").toData() else { return }
        
        await Network.put(urlString: "\(baseURL)/user/create", payload: payload) { err, data in
            callback(err, data)
        }
    }
    
    class func getUser(baseURL: String, user: User, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let timestamp = "".getTime()
        let signature = sessionless.sign(message: "\(timestamp)\(user.uuid)") ?? ""
        
        await Network.get(urlString: "\(baseURL)/user/\(user.uuid)?timestamp=\(timestamp)&signature=\(signature)", callback: callback)
    }
    
    class func getPrompt(baseURL: String, user: User, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let timestamp = "".getTime()
        let message = "\(timestamp)\(user.uuid)"
        let signature = sessionless.sign(message: message) ?? ""
        await Network.get(urlString: "\(baseURL)/user/\(user.uuid)/associate/prompt?timestamp=\(timestamp)&signature=\(signature)", callback: {err, data in
            callback(err, data)
        })
    }
    
    class func postPrompt(baseURL: String, user: User, prompt: String, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        
        guard let publicKey = sessionless.getKeys()?.publicKey,
              let payload = PostPrompt(timestamp: "".getTime(), uuid: user.uuid, pubKey: publicKey, prompt: prompt).toData() else { return }
        
        await Network.post(urlString: "\(baseURL)/user/\(user.uuid)/associate/signedPrompt", payload: payload, callback: {err, data in
            callback(err, data)
        })
    }
    
    class func associate(baseURL: String, user: User, signedPrompt: PostPrompt, callback: @escaping (Error?, Data?) -> Void) async {
        let timestamp = "".getTime()
        
        guard let payload = PostAssociate(timestamp: timestamp, newTimestamp: signedPrompt.timestamp, newUUID: signedPrompt.uuid, newPubKey: signedPrompt.pubKey, prompt: signedPrompt.prompt, newSignature: signedPrompt.signature, signature: "").toData() else { return }
        
        await Network.post(urlString: "\(baseURL)/user/\(user.uuid)/associate", payload: payload, callback: callback)
    }
    
    class func sendMessage(baseURL: String, user: User, content: String, receiverUUID: String, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        
        guard let payload = PostableMessage(timestamp: "".getTime(), senderUUID: user.uuid, receiverUUID: receiverUUID, content: content).toData() else { return }
        
        await Network.post(urlString: "\(baseURL)/message", payload: payload, callback: callback)
    }
    
    class func getMessages(baseURL: String, user: User, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let timestamp = "".getTime()
        let message = "\(timestamp)\(user.uuid)"
        guard let signature = sessionless.sign(message: message) else { return }
        
        await Network.get(urlString: "\(baseURL)/messages/user/\(user.uuid)?timestamp=\(timestamp)&signature=\(signature)", callback: callback)
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
