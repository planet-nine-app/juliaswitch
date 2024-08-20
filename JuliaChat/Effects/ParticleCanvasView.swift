//
//  ParticleCanvasView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/17/24.
//

import SwiftUI

struct ParticleCanvasView: View {
    let movementDuration: Double
    let particleCount: Int
    let startingParticleOffsets: [CGFloat]
    let startingParticleAlphas: [CGFloat]
    @Binding var emitterColor: Color
    @State var tagState = 0
    
    init(emitterColor: Binding<Color>, particleCount: Int = 200, movementDuration: Double = 3.0) {
        self._emitterColor = emitterColor
        self.particleCount = particleCount
        self.movementDuration = movementDuration
        self.startingParticleOffsets = Array(0..<particleCount).map {_ in CGFloat.random(in: 0...1)}
        self.startingParticleAlphas = Array(0..<particleCount).map {_ in CGFloat.random(in: 0...CGFloat.pi*2)}
    }
    
    func particlePositionAndAlpha(index: Int, timeInterval: Double, canvasSize: CGSize) -> (CGPoint, CGFloat) {
        let startingRotation: CGFloat = startingParticleAlphas[index]
        let startingTimeOffset = startingParticleOffsets[index]*movementDuration
        
        let time = (timeInterval+startingTimeOffset).truncatingRemainder(dividingBy: movementDuration)/movementDuration
        let rotations:CGFloat = 1.5
        let amplitude: CGFloat = 0.1+0.8*(1-time)
        
        let x = canvasSize.width/2 + cos(rotations*time*CGFloat.pi*2 + startingRotation)*canvasSize.width/2*amplitude*0.8
        let y = (1-time*time)*canvasSize.height
        
        return (CGPoint(x: x, y: y), 1-time)
    }
    
    var body: some View {
        TimelineView(.animation) { context in
            let timeInterval = context.date.timeIntervalSinceReferenceDate;
            
            Canvas { context, size in
                let particleSymbol = context.resolveSymbol(id: tagState)!
                
                for i in 0..<particleCount {
                    let positionAndAlpha = particlePositionAndAlpha(index: i, timeInterval: timeInterval, canvasSize: size)
                    context.opacity = positionAndAlpha.1
                    context.draw(particleSymbol, at: positionAndAlpha.0, anchor: .center)
                }
            } symbols: {
                CircleParticleView(color: emitterColor)
                    .tag(0)
                CircleParticleView(color: .orange)
                    .tag(1)
                CircleParticleView(color: .blue)
                    .tag(2)
                CircleParticleView(color: .green)
                    .tag(3)
                CircleParticleView(color: .yellow)
                    .tag(4)
            }
            .onChange(of: emitterColor) {
                switch emitterColor {
                case .orange: tagState = 1
                    break
                case .blue: tagState = 2
                    break
                case .green: tagState = 3
                    break
                case .yellow: tagState = 4
                    break
                default: tagState = 0
                }
            }
        }
        .background(.black)
    }
}


