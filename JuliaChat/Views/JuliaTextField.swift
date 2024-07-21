//
//  JuliaTextField.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/20/24.
//

import SwiftUI


struct JuliaTextField: View {
    @Binding var enteredText: String
    
    var body: some View {
        TextField("Enter Text", text: $enteredText)
            .frame(width: 160, height: 48, alignment: .center)
            .background(.white)
    }
}

