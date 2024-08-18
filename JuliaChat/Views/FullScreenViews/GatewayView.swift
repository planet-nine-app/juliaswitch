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
    
    
    var body: some View {
        ParticleCanvasView()
    }
    
    init(readRequestCallback: @escaping () -> String, spellReceivedCallback: @escaping (_ spell: Spell) -> Void, gateway: BLEMAGICPeripheral? = nil) {
        self.readRequestCallback = readRequestCallback
        self.spellReceivedCallback = spellReceivedCallback
        self.gateway = BLEMAGICPeripheral(readRequestCallback: readRequestCallback, spellReceivedCallback: spellReceivedCallback)
    }
}

