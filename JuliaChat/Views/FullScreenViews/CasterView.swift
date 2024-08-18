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
    
    
    var body: some View {
        ParticleCanvasView()
    }
    
    init(readCallback: @escaping (_: String) -> Spell, spellCastCallback: @escaping () -> Void, notifyCallback: @escaping (_: String) -> Void, spellName: String) {
        self.readCallback = readCallback
        self.spellCastCallback = spellCastCallback
        self.notifyCallback = notifyCallback
        self.spellName = spellName
        self.caster = BLEMAGICCentral(gatewayReadCallback: readCallback, spellCastCallback: spellCastCallback, gatewayNotifyCallback: notifyCallback)
    }
}

