//
//  CasterView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/18/24.
//

import SwiftUI

struct CasterView: View {
    let readCallback: (_ value: String) -> Spell
    let spellCastCallback: () -> Void
    let notifyCallback: (_ value: String) -> Void
    let spellName: String
    var caster: BLEMAGICCentral?
    @State var emitterColor = Color.blue
    
    
    var body: some View {
        ParticleCanvasView(emitterColor: $emitterColor)
    }
    
    init(readCallback: @escaping (_: String) -> Spell, spellCastCallback: @escaping () -> Void, notifyCallback: @escaping (_: String) -> Void, spellName: String) {
        self.readCallback = readCallback
        self.spellCastCallback = spellCastCallback
        self.notifyCallback = notifyCallback
        self.spellName = spellName
        self.caster = BLEMAGICCentral(gatewayReadCallback: rCallback, spellCastCallback: sCallback, gatewayNotifyCallback: nCallback)
    }
    
    func changeEmitterColor() -> Void {
        emitterColor = emitterColor == Color.green ? Color.yellow : Color.pink
    }
    
    func rCallback(_ value: String) -> Spell {
        emitterColor = Color.green
        return self.readCallback(value)
    }
    
    func sCallback() -> Void {
        changeEmitterColor()
        self.spellCastCallback()
    }
    
    func nCallback(_ value: String) -> Void {
        changeEmitterColor()
        self.notifyCallback(value)
    }
}

