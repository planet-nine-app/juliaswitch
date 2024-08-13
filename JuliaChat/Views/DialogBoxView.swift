//
//  DialogBoxView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/21/24.
//

import SwiftUI

struct PSDialogBoxStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 0, green: 0.6, blue: 0.2),
                    Color(red: 0, green: 0.8, blue: 0.4)
                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.white, lineWidth: 4)
            )
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
        }
    }

extension View {
    func psDialogBox() -> some View {
        self.modifier(PSDialogBoxStyle())
    }
}


struct DialogBoxStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 160)
            .foregroundColor(.green)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lineWidth: 6.0, antialiased: false)
                    .cornerRadius(24))
    }
}

struct DialogBoxView: View {
    let content: String

    
    
    var body: some View {
        Text(content)
            .psDialogBox()
            .foregroundColor(.white)
            .padding()
    }
}

#Preview {
    VStack {
        Spacer()
        DialogBoxView(content: "Here is what this looks like. What happens when the string gets really long and it reads like a paragraph? I wonder if there should be any arbitrary length limit or something like that")
        Spacer()
        Spacer()
        Spacer()
        Spacer()
    }
    
}
