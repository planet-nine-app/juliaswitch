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
    @Binding var log: String
    
    
    
    var body: some View {
        ZStack {
            ParticleCanvasView(emitterColor: $emitterColor)
            Text(log)
                .foregroundColor(.white)
                .background(.blue)
        }
    }
    
    init(log: Binding<String>, readRequestCallback: @escaping () -> String, spellReceivedCallback: @escaping (_ spell: Spell) -> Void, gateway: BLEMAGICPeripheral? = nil) {
        self.readRequestCallback = readRequestCallback
        self.spellReceivedCallback = spellReceivedCallback
        self._log = log
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

