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
    let imagePath: String
    let content: String
    let eightBitImage: UIImage?
    
    @State private var displayedText = ""
    @State private var currentIndex = 0
        
    let typewriterSpeed: Double = 0.05

    var body: some View {
           GeometryReader { geometry in
               ZStack(alignment: .bottomLeading) {
                   Text(displayedText)
                       .psDialogBox()
                       .foregroundColor(.white)
                       .padding()
                   
                   Image(uiImage: eightBitImage ?? UIImage(named: "gateway") ?? UIImage())
                       .resizable()
                       .scaledToFill()
                       .frame(width: 80, height: 80)
                       .clipShape(Circle())
                       .overlay(Circle().stroke(Color.white, lineWidth: 3))
                       .offset(x: 10, y: 40)
               }
               .frame(height: 160)
               .frame(maxWidth: .infinity)
               .onAppear(perform: animateText)
           }
       }
    
    private func animateText() {
        guard currentIndex < content.count else { return }
           
        displayedText += String(content[content.index(content.startIndex, offsetBy: currentIndex)])
        currentIndex += 1
           
        DispatchQueue.main.asyncAfter(deadline: .now() + typewriterSpeed) {
            animateText()
        }
    }
    

    init(imagePath: String, content: String, eightBitImage: UIImage?) {
        self.imagePath = imagePath
        self.content = content
        self.eightBitImage = ImageLoader.loadImage(fromPath: imagePath)
    }
}


