//
//  CircleParticleView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/17/24.
//

import SwiftUI

struct CircleParticleView: View {
    @Binding var color: Color
    
    var body: some View {
        Circle().fill(color.opacity(0.4))
            .frame(width:35, height:35)
            .blendMode(.plusLighter)
            .blur(radius: 10)
    }
}


