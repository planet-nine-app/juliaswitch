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
    
    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
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
