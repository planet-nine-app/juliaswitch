//
//  BLEMAGICCentral.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/16/24.
//

import Foundation
import CoreBluetooth

class BLEMAGICCentral {
    var twoWayPeripheral: BLETwoWayPeripheral!
    var twoWayCentral: BLETwoWayCentral!
    let spellCastCallback: (_ spell: Spell) -> Void
    let bleCharacteristics = BLECharacteristics()
    var shouldListenForSpell = false
    var incomingSpell: Data!
    
    init(spellCastCallback: @escaping (_ spell: Spell) -> Void) {
        twoWayCentral = BLETwoWayCentral()
        self.spellCastCallback = spellCastCallback
        twoWayCentral.readCallback = self.readCallback
        twoWayCentral.notifyCallback = self.notifyCallback
    }
    
    func readCallback(value: String) -> Void {
        // In a real implementation, you may use this to negotiate some sort of
        // sense that this gateway, and your caster are part of the same network
        print("got a read request")
    }
    
    func notifyCallback(value: String) -> Void {
        print("notified")
    }
    
}
