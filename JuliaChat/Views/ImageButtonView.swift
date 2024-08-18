//
//  ImageButtonView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/17/24.
//

import SwiftUI

struct ImageButtonView: View {
    let image: UIImage
    let onPress: () -> Void
    
    struct CircularImageButtonStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .frame(width: 120, height: 120)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.purple, .green, .purple],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 4
                        )
                )
                .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
        }
    }
    
    
    var body: some View {
        Button(action: onPress) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(30)
                .foregroundColor(.white)
        }
        .buttonStyle(PlainButtonStyle())
        .modifier(CircularImageButtonStyle())
    }
}

struct SpellbookButton: View {
    let onPress: () -> Void

    var body: some View {
        ImageButtonView(image: UIImage(imageLiteralResourceName: "spellbook"), onPress: onPress)
    }
}

struct GatewayButton: View {
    let onPress: () -> Void

    var body: some View {
        ImageButtonView(image: UIImage(imageLiteralResourceName: "gateway"), onPress: onPress)
    }
}

