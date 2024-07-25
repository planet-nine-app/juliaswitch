//
//  DialogBoxView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/21/24.
//

import SwiftUI

struct DialogBoxStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 160, height: 160)
            .foregroundColor(.green)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(   LinearGradient(
                        colors: [.purple, .green, .purple],
                        startPoint: .top,
                        endPoint: .bottom),
                        lineWidth: 8)
                    )
                    .cornerRadius(24)
    }
}

struct DialogBoxView: View {
    let content: String

    
    
    var body: some View {
            ZStack {
                Rectangle()
                    .modifier(DialogBoxStyle())
                Text(content)
            }
    }
}
