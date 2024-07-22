//
//  JuliaButton.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/21/24.
//

import SwiftUI

struct ConnectionView: View {
    let onPress: () -> Void
    let label: String
    
    struct ConnectionButtonStyle: ButtonStyle {
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: 160, height: 160, alignment: .center)
                .background(.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .opacity(configuration.isPressed ? 0.5 : 1)
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
    
    var body: some View {
        Button() {
            onPress()
        } label: {
            Text(label)
        }.buttonStyle(ConnectionButtonStyle())
    }
    
    init(label: String, onPress: @escaping () -> Void) {
        self.onPress = onPress
        self.label = label
    }
}


