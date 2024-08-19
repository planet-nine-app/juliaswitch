//
//  CasterView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/18/24.
//

import SwiftUI

struct GatewayView: View {
    let readRequestCallback: () -> String
    let spellReceivedCallback: (_ spell: Spell) -> Void
    var gateway: BLEMAGICPeripheral?
    @State var emitterColor = Color.purple
    
    
    
    var body: some View {
        ParticleCanvasView(emitterColor: $emitterColor)
    }
    
    init(readRequestCallback: @escaping () -> String, spellReceivedCallback: @escaping (_ spell: Spell) -> Void, gateway: BLEMAGICPeripheral? = nil) {
        self.readRequestCallback = readRequestCallback
        self.spellReceivedCallback = spellReceivedCallback
        self.gateway = BLEMAGICPeripheral(readRequestCallback: readCallback, spellReceivedCallback: spellCallback(_:))
    }
    
    func changeEmitterColor() -> Void {
        emitterColor = emitterColor == Color.purple ? Color.orange : Color.pink
    }
    
    func readCallback() -> String {
        changeEmitterColor()
        return self.readRequestCallback()
    }
    
    func spellCallback(_ spell: Spell) -> Void {
        changeEmitterColor()
        self.spellReceivedCallback(spell)
    }
}

