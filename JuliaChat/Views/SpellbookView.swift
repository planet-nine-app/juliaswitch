//
//  SpellbookView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/17/24.
//

import SwiftUI

// Gonna just hack a quick and dirty solution here.
// The spellbook should come from the BDO for the pubKey
// that runs Julia, but that requires everything be hosted
// and we're a bit aways from that.
// The effects need to be built out too so we're just going
// to pants it here for now.

struct SpellbookSpell: Identifiable {
    var id: String
    let name: String
    let effect: String
    
    init(name: String, effect: String) {
        self.id = "\(name)\(effect)"
        self.name = name
        self.effect = effect
    }
}

struct Spellbook {
    let spells: [SpellbookSpell]
}

struct SpellbookView: View {
    let spellbook = Spellbook(spells: [
        SpellbookSpell(name: "connect", effect: "connect")
    ])
    @Binding var isPresented: Bool
    
    @State private var animationProgress: CGFloat = 0
    @State private var contentOpacity: Double = 0
    
    var body: some View {
        ZStack {
            if isPresented {
                VStack {
                    ForEach(spellbook.spells) { spell in
                        HStack {
                            Text(spell.name)
                            Spacer()
                            ParticleCanvasView()
                        }
                    }
                }
                .padding()
                .opacity(contentOpacity)
                .animation(.easeIn(duration: 0.5).delay(0.5), value: contentOpacity)
                .overlay(
                    GeometryReader { geometry in
                        Path { path in
                            let width = geometry.size.width
                            let height = geometry.size.height
                            
                            path.move(to: CGPoint(x: width, y: height))
                            path.addLine(to: CGPoint(x: 0, y: height))
                            path.addLine(to: CGPoint(x: 0, y: 0))
                        }
                        .trim(from: 0, to: animationProgress)
                        .stroke(Color.green, lineWidth: 6)
                        Path { path in
                            let width = geometry.size.width
                            let height = geometry.size.height
                            
                            path.move(to: CGPoint(x: width, y: height))
                            path.addLine(to: CGPoint(x: width, y: 0))
                            path.addLine(to: CGPoint(x: 0, y: 0))
                        }
                        .trim(from: 0, to: animationProgress)
                        .stroke(Color.green, lineWidth: 6)
                    }
                )
            }
        }
        .onChange(of: isPresented) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animationProgress = 1
                }
                withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
                    contentOpacity = 1
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    animationProgress = 0
                    contentOpacity = 0
                }
            }
        }
    }
}

