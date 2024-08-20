//
//  BLEMAGICCentral.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/16/24.
//

import Foundation
import CoreBluetooth

class BLEMAGICCentral {
    var twoWayCentral: BLETwoWayCentral!
    let gatewayReadCallback: (_ value: String) async -> Spell
    let spellCastCallback: () -> Void
    let gatewayNotifyCallback: (_ value: String) -> Void
    let bleCharacteristics = BLECharacteristics()
    var shouldListenForSpell = false
    var incomingSpell: Data!
    
    init(gatewayReadCallback: @escaping (_ value: String) async -> Spell, spellCastCallback: @escaping () -> Void, gatewayNotifyCallback: @escaping (_ value: String) -> Void) {
        twoWayCentral = BLETwoWayCentral()
        self.gatewayReadCallback = gatewayReadCallback
        self.spellCastCallback = spellCastCallback
        self.gatewayNotifyCallback = gatewayNotifyCallback
        twoWayCentral.readCallback = self.readCallback
        twoWayCentral.notifyCallback = self.notifyCallback
    }
    
    func castSpell(spell: Spell) -> Void {
        guard let spellData = spell.toData() else { return }
        twoWayCentral.writeToGateway(data: spellData)
    }
    
    func readCallback(value: String) async -> Void {
        // In a real implementation, you may use this to negotiate some sort of
        // sense that this gateway, and your caster are part of the same network
        print("got a read request")
        let spell = await gatewayReadCallback(value)
        castSpell(spell: spell)
    }
    
    func notifyCallback(value: String) -> Void {
        print("notified")
        gatewayNotifyCallback(value)
    }
    
}
