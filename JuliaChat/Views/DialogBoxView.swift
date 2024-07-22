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
            .frame(width: 160, height: 160, alignment: .center)
            .background(.green)
            .foregroundColor(.white)
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
    @Binding var enteredText: String
    
    
    
    var body: some View {
        GeometryReader() { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            
            JuliaTextField(enteredText: $enteredText)
                .modifier(DialogBoxStyle())

        }
    }
}
