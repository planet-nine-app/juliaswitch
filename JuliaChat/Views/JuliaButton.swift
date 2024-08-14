//
//  JuliaButton.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/20/24.
//

import SwiftUI

struct JuliaButton: View {
    let onPress: () -> Void
    let label: String
    
    struct JuliaButtonStyle: ButtonStyle {
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: 160, height: 48, alignment: .center)
                .foregroundColor(.white)
                .cornerRadius(10)
                .opacity(configuration.isPressed ? 0.5 : 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(Color.white, lineWidth: 4)
                        .cornerRadius(24))
        }
    }
    
    var body: some View {
        Button() {
            onPress()
        } label: {
            Text(label)
                .overlay {
                    LinearGradient(colors: [.purple, .green], startPoint: .top, endPoint: .bottom)
                }
                .mask {
                    Text(label)
                }
        }.buttonStyle(JuliaButtonStyle())
    }
    
    init(label: String, onPress: @escaping () -> Void) {
        self.onPress = onPress
        self.label = label
    }
}


