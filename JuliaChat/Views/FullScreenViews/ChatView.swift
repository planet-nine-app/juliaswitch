//
//  ChatView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/17/24.
//

import SwiftUI
import SwiftData

struct ChatView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var users: [User]
    @Query private var preferences: [Preferences]
    let backgroundImage = ImageResource(name: "space", bundle: Bundle.main)
    @State var enteredText = ""
    @State private var textFieldOffset: CGFloat = 0
    @State private var textFieldOpacity: Double = 1
    @State private var isAnimating = false
    var messageStrings: [String] {
        return users[0].messages.filter({ $0.receiverUUID == users[0].juliaUUID }).map({ $0.message })
    }
    @Binding var viewState: Int
    @Binding var receiverUUID: String
    
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
            
            ZStack {
                Image(backgroundImage)
                
                VStack {
                    VStack {
                        DialogBoxView(imagePath: preferences[0].appPreferences["\(receiverUUID)Image"] ?? "", content: messageStrings.count > 0 ? messageStrings[0] : "Here is where you put all the text for the DialogBoxView \(users[0].messages.count)", eightBitImage: (preferences[0].appPreferences["\(receiverUUID)Image"] != nil) ? ImageLoader.loadImage(fromPath: preferences[0].appPreferences["\(receiverUUID)Image"]!) : nil)
                        /*List(users[0].messages) { message in
                            DialogBoxView(content: message.message)
                        }*/
                    }
                    Spacer()
                    //Text("FOO")
                    HStack {
                        DialogBoxTextFieldView(enteredText: $enteredText)
                            .offset(y: textFieldOffset)
                            .opacity(textFieldOpacity)
                        JuliaButton(label: "Send") {
                            Task {
                                await Network.sendMessage(baseURL: ServiceURLs.julia.rawValue, user: users[0], content: enteredText, receiverUUID: receiverUUID) { err, data in
                                    if let err = err {
                                        print("EROROROR")
                                        print(err)
                                        enteredText = "ERRORRRORR \(err)"
                                        return
                                    }
                                    if let data = data {
                                        animateTextField()
                                        print("Maybe success")
                                        print(String(data: data, encoding: .utf8))
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .frame(width: w, height: h)
            }
            .onAppear {
                print(messageStrings)
                //messageStrings = users[0].messages.filter({ $0.receiverUUID == users[0].juliaUUID }).map({ $0.message })
                print(messageStrings)
            }
            .frame(width: w, height: h)
        }
    }
    
    private func animateTextField() {
            guard !isAnimating else { return }
            isAnimating = true
        
            withAnimation(.easeOut(duration: 0.45)) {
                textFieldOpacity = 0
            }
                
            // Fly off screen
            withAnimation(.easeInOut(duration: 0.5)) {
                textFieldOffset = -UIScreen.main.bounds.height
            }
            
            // Wait a moment, then fade back in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                // Reset position instantly
                textFieldOffset = 0
                
                withAnimation(.easeIn(duration: 0.3)) {
                    textFieldOpacity = 1
                }
                
                // Clear the text and reset animation flag
                enteredText = ""
                isAnimating = false
            }
        }
    
    /*init(viewState: Binding<Int>, receiverUUID: Binding<String>) {
        self._viewState = viewState
        self._receiverUUID = receiverUUID
        
        self.messageStrings = users[0].messages.filter({ $0.receiverUUID == users[0].juliaUUID }).map({ $0.message })
    }*/
}
