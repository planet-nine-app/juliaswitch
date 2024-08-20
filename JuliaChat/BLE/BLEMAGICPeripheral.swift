//
//  MAGICGateway.swift
//  PlanetNineGateway
//
//  Created by Zach Babb on 2/6/19.
//  Copyright © 2019 Planet Nine. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEMAGICPeripheral {
    var twoWayPeripheral: BLETwoWayPeripheral!
    let readRequestCallback: () -> String
    let spellReceivedCallback: (_ spell: Spell) -> Void
    let bleCharacteristics = BLECharacteristics()
    var shouldListenForSpell = false
    var incomingSpell: Data!
    
    init(readRequestCallback: @escaping () -> String, spellReceivedCallback: @escaping (_ spell: Spell) -> Void) {
        twoWayPeripheral = BLETwoWayPeripheral()
        self.readRequestCallback = readRequestCallback
        self.spellReceivedCallback = spellReceivedCallback
        twoWayPeripheral.readCallback = self.readCallback
        twoWayPeripheral.writeCallback = self.writeCallback
        twoWayPeripheral.notifyCallback = self.notifyCallback
    }
    
    func readCallback(characteristic: CBCharacteristic) -> String {
        // In a real implementation, you may use this to negotiate some sort of
        // sense that this gateway, and your caster are part of the same network
        print("got a read request")
        return self.readRequestCallback()
    }
    
    func writeCallback(value: String, central: CBCentral) {
        print("value written \(value)")
        
        spellReceivedCallback(Spell())
    }
    
    func notifyCallback(characteristic: CBCharacteristic) -> String {
        print("notified")
        guard let value = characteristic.value else { return "" }
        if shouldListenForSpell {
            incomingSpell.append(value)
        }
        return ""
    }
    
}
