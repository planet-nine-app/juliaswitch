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
                                await Network.postPrompt(baseURL: "http://localhost:3000", user: users[0], prompt: enteredText) { err, data in
                                    if let err = err {
                                        print(err)
                                        return
                                    }
                                    if let data = data {
                                        if String(data: data, encoding: .utf8)?.contains("true") == true {
                                            print("Great success")
                                        } else {
                                            print("Terrible failure")
                                        }
                                    }
                                    print("no data")
                                }
                            }
                        }
                        .transition(.slide)
                        JuliaButton(label: "getPrompt") {
                            // Call network to get prompt
                            print("get prompt tapped")
                            Task {
                                await Network.getPrompt(baseURL: "http://localhost:3000", user: users[0]) { error, data in
                                    if let error = error {
                                        print(error)
                                        return
                                    }
                                    if let data = data {
                                        print(String(data: data, encoding: .utf8))
                                        do {
                                            let user = try JSONDecoder().decode(User.self, from: data)
                                            print("SUCCESS")
                                            print(user)
                                            print(user.uuid)
                                            modelContext.insert(user)
                                            try? modelContext.save()
                                        } catch {
                                            print("Decoding or saving failed ")
                                            print(error)
                                            return
                                        }
                                    }
                                }
                            }
                        }
                        .transition(.move(edge: .trailing))
                    }
                    
                    JuliaButton(label: "handlePrompts") {
                        promptsOpen = !promptsOpen
                    }
                }
                .frame(width: 160, height: 48, alignment: .center)
                .position(x: w / 2, y: h * 0.75)
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
