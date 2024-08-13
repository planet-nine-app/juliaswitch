//
//  ResponseHandler.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/12/24.
//

import Foundation
import SwiftData

class ResponseHandler {
    
    class func handlerForModel<T: Codable>(
        for type: T.Type,
        completion: @escaping (Error?, T?) -> Void
    ) -> (Error?, Data?) -> Void {
        return { err, data in
            if let err = err {
                print("error")
                print(err)
                completion(err, nil)
                return
            }
            
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8) ?? "Unable to print data")
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                print("SUCCESS")
                print(decodedObject)
                completion(nil, decodedObject)
            } catch {
                print("Decoding or saving failed ")
                print(error)
                return
            }
        }
    }
}
