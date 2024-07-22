//
//  ChatView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/17/24.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.modelContext) var modelContext
    let backgroundImage = ImageResource(name: "space", bundle: Bundle.main)
    @Binding public var displayText: String
    @State var enteredText = ""
    
    struct CustomButtonStyle: ButtonStyle {
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .foregroundColor(.white)
                .cornerRadius(10)
                .opacity(configuration.isPressed ? 0.5 : 1)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            let _ = print(w)
            ZStack {
                Image(backgroundImage)
                DialogBoxView(enteredText: $enteredText)
            }
        }
    }
}
