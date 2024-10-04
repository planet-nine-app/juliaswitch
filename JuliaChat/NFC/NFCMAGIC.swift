//
//  NFCMAGIC.swift
//  JuliaChat
//
//  Created by Zach Babb on 9/29/24.
//

import Foundation
import CoreNFC

class NFCReader: NSObject, NFCNDEFReaderSessionDelegate {
    var nfcSession: NFCNDEFReaderSession?
    
    func startScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC reading not available on this device")
            return
        }
        
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let string = String(data: record.payload, encoding: .utf8) {
                    print("NFC Content: \(string)")
                }
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("NFC Session invalidated: \(error.localizedDescription)")
    }
}

// Usage
//let nfcReader = NFCReader()
//nfcReader.startScanning()
