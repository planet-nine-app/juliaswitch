//
//  JuliaButton.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/21/24.
//

import SwiftUI

import SwiftUI

struct ConnectionView: View {
    @State var textfieldOn = false
    @State var enteredText = ""
    @State var handle: String
    let connection: KeyTuple
    let onPress: () -> Void
    let label: String
    let imageName: String
    
    struct CircularConnectionStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .frame(width: 120, height: 120)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.green, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.purple, .green, .purple],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 4
                        )
                )
                .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
        }
    }
    
    var body: some View {
        VStack {
            Button(action: onPress) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(30)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
            .modifier(CircularConnectionStyle())
            
            if textfieldOn {
                JuliaTextField(label: handle, enteredText: $enteredText)
                    .onSubmit {
                        print("take care of pref here")
                        print(enteredText)
                    }
            } else {
                Text(label)
                    .frame(width: 140, height: 24)
                    .font(.headline)
                    .foregroundColor(.white)
                    .shadow(color: .purple.opacity(0.7), radius: 3, x: 0, y: 2)
                    .onTapGesture {
                        textfieldOn = true
                    }
            }
        }
    }
    
    init(label: String, handle: String, imageName: String, connection: KeyTuple, onPress: @escaping () -> Void) {
        self.onPress = onPress
        self.label = label
        self.handle = handle
        self.imageName = imageName
        self.connection = connection
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static let tuple = KeyTuple(uuid: "foo", pubKey: "bar")
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ConnectionView(label: "Connect", handle: "foo", imageName: "network", connection: tuple, onPress: {})
        }
    }
}


