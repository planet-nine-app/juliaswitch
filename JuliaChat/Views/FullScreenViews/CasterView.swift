//
//  CasterView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/18/24.
//

import SwiftUI

class CasterViewModel: ObservableObject {
    @Published var emitterColor: Color = .blue
    @Published var log: String = ""
    
    let readCallback: (_ value: String) async -> Spell
    let spellCastCallback: () -> Void
    let notifyCallback: (_ value: String) -> Void
    let spellName: String
    var caster: BLEMAGICCentral?
    
    init(readCallback: @escaping (_ value: String) async -> Spell,
         spellCastCallback: @escaping () -> Void,
         notifyCallback: @escaping (_ value: String) -> Void,
         spellName: String) {
        self.readCallback = readCallback
        self.spellCastCallback = spellCastCallback
        self.notifyCallback = notifyCallback
        self.spellName = spellName
        self.caster = BLEMAGICCentral(gatewayReadCallback: self.rCallback,
                                      spellCastCallback: self.sCallback,
                                      gatewayNotifyCallback: self.nCallback)
    }
    
    func changeEmitterColor() {
        emitterColor = emitterColor == .green ? .yellow : .pink
        log += "\nshould change emitterColor to: \(emitterColor)"
    }
    
    func rCallback(_ value: String) async -> Spell {
        DispatchQueue.main.async {
            self.emitterColor = .green
            self.changeEmitterColor()
        }
        return await self.readCallback(value)
    }
    
    func sCallback() {
        changeEmitterColor()
        self.spellCastCallback()
    }
    
    func nCallback(_ value: String) {
        changeEmitterColor()
        self.notifyCallback(value)
    }
}

struct CasterView: View {
    @StateObject private var viewModel: CasterViewModel
    @Binding var viewState: Int
    
    init(viewState: Binding<Int>, readCallback: @escaping (_ value: String) async -> Spell,
         spellCastCallback: @escaping () -> Void,
         notifyCallback: @escaping (_ value: String) -> Void,
         spellName: String) {
        self._viewState = viewState
        _viewModel = StateObject(wrappedValue: CasterViewModel(
            readCallback: readCallback,
            spellCastCallback: spellCastCallback,
            notifyCallback: notifyCallback,
            spellName: spellName
        ))
    }
    
    var body: some View {
        ZStack {
            ParticleCanvasView(emitterColor: $viewModel.emitterColor, log: $viewModel.log)
            Text(viewModel.log)
                .foregroundColor(.white)
                .background(.blue)
                .onTapGesture {
                    viewState = 1
                }
        }
    }
}

