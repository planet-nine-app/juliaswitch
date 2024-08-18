//
//  CircleParticleView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/17/24.
//

import SwiftUI

struct CircleParticleView: View {
    var body: some View {
        Circle().fill(Color.purple.opacity(0.4))
            .frame(width:35, height:35)
            .blendMode(.plusLighter)
            .blur(radius: 10)
    }
}

#Preview {
    CircleParticleView()
}
