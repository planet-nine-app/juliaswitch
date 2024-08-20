//
//  CasterView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/18/24.
//

import SwiftUI

struct CasterView: View {
    let readCallback: (_ value: String) async -> Spell
    let spellCastCallback: () -> Void
    let notifyCallback: (_ value: String) -> Void
    let spellName: String
    var caster: BLEMAGICCentral?
    @State var emitterColor = Color.blue
    @Binding var log: String
    
    
    var body: some View {
        ZStack {
            ParticleCanvasView(emitterColor: $emitterColor)
            Text(log)
                .foregroundColor(.white)
                .background(.blue)
        }
    }
    
    init(log: Binding<String>, readCallback: @escaping (_: String) async -> Spell, spellCastCallback: @escaping () -> Void, notifyCallback: @escaping (_: String) -> Void, spellName: String) {
        self.readCallback = readCallback
        self.spellCastCallback = spellCastCallback
        self.notifyCallback = notifyCallback
        self.spellName = spellName
        self._log = log
        self.caster = BLEMAGICCentral(gatewayReadCallback: rCallback, spellCastCallback: sCallback, gatewayNotifyCallback: nCallback)
    }
    
    func changeEmitterColor() -> Void {
        emitterColor = emitterColor == Color.green ? Color.yellow : Color.pink
    }
    
    func rCallback(_ value: String) async -> Spell {
        emitterColor = Color.green
        return await self.readCallback(value)
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

