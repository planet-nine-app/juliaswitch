//
//  DialogBoxView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/21/24.
//

import SwiftUI

struct DialogBoxTextFieldStyle: ViewModifier {
    
    
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

struct DialogBoxTextFieldView: View {
    @Binding var enteredText: String
    
    
    
    var body: some View {
            ZStack {
                Rectangle()
                    .modifier(DialogBoxTextFieldStyle())
                JuliaTextField(label: "chat", enteredText: $enteredText)
                    .background(.green)
            }
    }
}
