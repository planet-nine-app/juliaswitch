//
//  PlanetNineView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/17/24.
//

import SwiftUI

struct PlanetNineView: View {
    let backgroundImage = ImageResource(name: "space", bundle: Bundle.main)
    @State var displayText = "Hello World"

    var body: some View {
        ZStack {
            Image(backgroundImage)

            Text(displayText)
                .font(.title3)
                .foregroundStyle(.green)
                .frame(width: 300, height: 300, alignment: .top)
                .background(.black)
                .clipShape(Circle())
                //.overlay(RoundedRectangle(cornerRadius: 150.0))
        }
    }
}
