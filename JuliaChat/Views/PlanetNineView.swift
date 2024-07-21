//
//  PlanetNineView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/17/24.
//

import SwiftUI

struct PlanetNineView: View {
    @Environment(\.modelContext) var modelContext
    let backgroundImage = ImageResource(name: "space", bundle: Bundle.main)
    @Binding public var displayText: String
    @State var enteredText = ""
    let baseURL = "http://localhost:3000"
    
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
                
                VStack {
                    Text(LocalizedStringKey(displayText))
                        .font(.title3)
                        .foregroundStyle(.green)
                        .frame(width: w - 32, height: w - 32, alignment: .center)
                        .background(.black)
                        .clipShape(Circle())
                }
                .position(x: w / 2, y: 250)
            }
        }
    }
}
