//
//  ContactsView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/17/24.
//

import SwiftUI
import SwiftData

struct ConnectionsView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var users: [User]
    @State var displayText: String = "noConnections"
    @State var promptsOpen: Bool = false
    @State var enteredText: String = ""
    @Binding var viewState: Int
    @Binding var receiverUUID: String
    
    let backgroundImage = ImageResource(name: "space", bundle: Bundle.main)

    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            ZStack {
                PlanetNineView(displayText: $displayText)
                VStack {
                    if promptsOpen {
                        JuliaTextField(enteredText: $enteredText)
                            .transition(.push(from: .trailing))
                        JuliaButton(label: "enterPrompt") {
                            // Enter prompt
                            print("prompt is: \(enteredText)")
                            Task {
                                await Julia.postPrompt(user: users[0], prompt: enteredText) { err, success in
                                    if let err = err {
                                        print("uierr")
                                        return
                                    }
                                }
                            }
                        }
                        .transition(.slide)
                        JuliaButton(label: "getPrompt") {
                            // Call network to get prompt
                            print("get prompt tapped")
                            Task {
                                await Julia.getPrompt(user: users[0]) { err, user in
                                    if let err = err {
                                        print("uierr")
                                        return
                                    }
                                    if let user = user {
                                        modelContext.insert(user)
                                        try? modelContext.save()
                                    }
                                }
                            }
                        }
                        .transition(.move(edge: .trailing))
                        if !users[0].pendingPrompts.isEmpty {
                           
                            ForEach(users[0].promptsAsArray()) { prompt in
                                if prompt.newPubKey != nil {
                                    let _ = print("boom! add that button")
                                    JuliaButton(label: "Accept \(prompt.prompt)") {
                                        print("Accept the prompt here")
                                        let postPrompt = PostPrompt(timestamp: prompt.timestamp, uuid: prompt.newUUID ?? "", pubKey: prompt.newPubKey ?? "", prompt: prompt.prompt ?? "", signature: prompt.newSignature ?? "")
                                        Task {
                                            await Julia.associate(user: users[0], signedPrompt: postPrompt) { err, user in
                                                if let err = err {
                                                    print("uierr")
                                                    return
                                                }
                                                if let user = user {
                                                    modelContext.insert(user)
                                                    try? modelContext.save()
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    let _ = print("If it's getting here, what heck is \(prompt.toString())")
                                }
                            }
                        }
                    }
                    
                    JuliaButton(label: "handlePrompts") {
                        promptsOpen = !promptsOpen
                        /*Task {
                            await PlanetNine.createUser { err, planetNineUser in
                                if let err = err {
                                    print("uierr")
                                    return
                                }
                                if let planetNineUser = planetNineUser {
                                    modelContext.insert(planetNineUser)
                                    try? modelContext.save()
                                    viewState = 1
                                }
                            }
                        }*/
                    }
                }
                .background(.blue)
                .frame(width: 160, height: 48, alignment: .center)
                .position(x: w / 2, y: h * 0.75)
                HStack {
                    ForEach(users[0].connections(), id: \.uuid) { tuple in
                        ConnectionView(label: tuple.uuid) {
                            print("Tapped a connection")
                            receiverUUID = tuple.uuid
                            viewState = 2
                        }
                    }
                }
            }
            .onAppear {
                let user = users[0]
                if user.keys.interactingKeys.count == 0 {
                    displayText = "noConnections"
                }
            }
        }
    }
}
