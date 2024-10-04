//
//  CasterView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/18/24.
//

import SwiftUI

class GatewayViewModel: ObservableObject {
    @Published var emitterColor: Color = .purple
    @Published var log: String = ""
    
    let readRequestCallback: () -> String
    let spellReceivedCallback: (Spell) -> Void
    var gateway: BLEMAGICPeripheral?
    
    init(readRequestCallback: @escaping () -> String, spellReceivedCallback: @escaping (Spell) -> Void) {
        self.readRequestCallback = readRequestCallback
        self.spellReceivedCallback = spellReceivedCallback
        self.gateway = BLEMAGICPeripheral(readRequestCallback: self.readCallback, spellReceivedCallback: self.spellCallback)
    }
    
    func changeEmitterColor() {
        emitterColor = emitterColor == .purple ? .orange : .pink
        log += "\nshould change emitterColor to: \(emitterColor)"
    }
    
    func readCallback() -> String {
        changeEmitterColor()
        return readRequestCallback()
    }
    
    func spellCallback(_ spell: Spell) {
        changeEmitterColor()
        spellReceivedCallback(spell)
    }
    
    func foo(_ dict: [String: String]) {
        print(dict)
    }
    
    func bar() {
        foo(["changeMe": "value"])
        foo(["changeMe": "anotherValue"])
    }
}

struct GatewayView: View {
    @StateObject private var viewModel: GatewayViewModel
    @Binding var viewState: Int
    
    init(viewState: Binding<Int>, readRequestCallback: @escaping () -> String, spellReceivedCallback: @escaping (Spell) -> Void) {
        self._viewState = viewState
        _viewModel = StateObject(wrappedValue: GatewayViewModel(readRequestCallback: readRequestCallback, spellReceivedCallback: spellReceivedCallback))
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

