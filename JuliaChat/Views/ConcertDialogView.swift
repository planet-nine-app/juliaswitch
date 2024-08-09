//
//  DialogBoxView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/21/24.
//

import SwiftUI

struct ConcertDialogStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.green)
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

struct ConcertDialogView: View {
    let popup: Popup
    @Binding var popupChosen: Bool
    @Binding var chosenPopup: Popup

    var body: some View {
            ZStack {
                VStack {
                    Spacer()
                    Text(popup.name)
                    Spacer()
                    HStack {
                        Spacer()
                        Text(popup.description)
                        Spacer()
                    }
                    Spacer()
                    Text(popup.location)
                    Spacer()
                }
            }
            .onTapGesture {
                print("HEYOOOO")
                chosenPopup = popup
                popupChosen = true
                print("oooooooyeh")
            }
            .modifier(ConcertDialogStyle())
            
    }
}
