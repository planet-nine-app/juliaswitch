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
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: payload)
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
            let (data, _) = try await URLSession.shared.upload(for: request, from: payload)
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
    
    class func checkForPrompt(baseURL: String, user: User, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let timestamp = "".getTime()
        let signature = "\(timestamp)\(user.uuid)"
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
    
    class func getValue(baseURL: String, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let timestamp = "".getTime()
        let uuid = Persistence.getUUID()
        let message = """
        {"timestamp":"\(timestamp)","uuid":"\(uuid)"}
        """
        
        guard let signature = sessionless.sign(message: message) else { return }
        
        let urlString = "timestamp=\(timestamp)&uuid=\(uuid)&signature=\(signature)"
        guard let urlEncodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        await Network.get(urlString: "\(baseURL)/value?\(urlEncodedString)", callback: callback)
    }
    
    class func setValue(value: String, baseURL: String, callback: @escaping (Error?, Data?) -> Void) async {
        let sessionless = Sessionless()
        let message = """
        {"timestamp":"\("".getTime())","uuid":"\(Persistence.getUUID())","value":"\(value)"}
        """
        
        guard let signature = sessionless.sign(message: message) else { return }
        
        let payload = """
        {"timestamp":"\("".getTime())","uuid":"\(Persistence.getUUID())","value":"\(value)","signature":"\(signature)"}
        """
        
        guard let data = payload.data(using: .utf8) else { return }
        await Network.post(urlString: "\(baseURL)/value", payload: data, callback: callback)
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
