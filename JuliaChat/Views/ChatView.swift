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
    let backgroundImage = ImageResource(name: "space", bundle: Bundle.main)
    @State var enteredText = ""
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
                        List(users[0].messages) { message in
                            DialogBoxView(content: message.message)
                        }
                    }
                    Spacer()
                    //Text("FOO")
                    HStack {
                        DialogBoxTextFieldView(enteredText: $enteredText)
                        JuliaButton(label: "Send") {
                            Task {
                                await Network.sendMessage(baseURL: "http://localhost:3000", user: users[0], content: enteredText, receiverUUID: receiverUUID) { err, data in
                                    if let err = err {
                                        print("EROROROR")
                                        print(err)
                                        return
                                    }
                                    if let data = data {
                                        print("Maybe success")
                                        print(String(data: data, encoding: .utf8))
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .frame(width: w, height: h)
                .background(.blue)
            }
            .frame(width: w, height: h)
        }
    }
}
