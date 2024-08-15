//
//  JuliaTextField.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/20/24.
//

import SwiftUI


struct JuliaTextField: View {
    let label: String
    @Binding var enteredText: String
    
    struct JuliaTextFieldStyle: TextFieldStyle {
        
        func _body(configuration: TextField<Self._Label>) -> some View {
                    configuration
                        .padding()
                        .frame(width: 140, height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .strokeBorder(Color.white, lineWidth: 4)
                        )
                        .foregroundColor(.white)
                }
    }
    
    var body: some View {
        TextField(label, text: $enteredText)
            .textFieldStyle(JuliaTextFieldStyle())
    }
}

