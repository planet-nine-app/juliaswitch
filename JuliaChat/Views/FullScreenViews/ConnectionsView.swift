//
//  ContactsView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/17/24.
//

import SwiftUI
import SwiftData
import CoreBluetooth

struct ConnectionsView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var users: [User]
    @Query private var planetNineUsers: [PlanetNineUser]
    @Query private var preferences: [Preferences]
    @State var displayText: String = ""
    @State var promptsOpen: Bool = false
    @State var enteredText: String = ""
    @State var openSpellbook: Bool = false
    @State var showImagePicker: Bool = false
    @State var selectedImage: UIImage?
    @State var selectedTuple: KeyTuple?
    @Binding var viewState: Int
    @Binding var receiverUUID: String
    
    let backgroundImage = ImageResource(name: "space", bundle: Bundle.main)
    
    func postPrompt() async {
        Task {
            await Julia.postPrompt(user: users[0], prompt: enteredText) { err, success in
                if let err = err {
                    print("uierr")
                    return
                }
            }
        }
    }
    
    func getPrompt() async {
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
    
    func acceptPrompt(prompt: Prompt) async {
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

    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            ZStack {
                if displayText != "" {
                    PlanetNineView(displayText: $displayText)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Image(backgroundImage)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                }
                VStack {
                    Spacer()
                    if displayText != "" {
                        Spacer()
                    }
                    let _ = print("should \(openSpellbook ? "" : "not ") open up spellbook")
                    SpellbookView(isPresented: $openSpellbook, viewState: $viewState)
                        .frame(width: 200, height: 200)
                        .background(.clear)
                    HStack {
                        ForEach(users[0].connections(), id: \.uuid) { tuple in
                            
                            let handle = preferences.count > 0 && preferences[0].appPreferences["\(tuple.uuid)Handle"] != nil ? preferences[0].appPreferences["\(tuple.uuid)Handle"]! : tuple.uuid
                                
                            ConnectionView(label: tuple.uuid, handle: handle, imageName: preferences[0].appPreferences["\(tuple.uuid)Image"] ?? "julia", connection: tuple, addOrUpdateImage: {
                                selectedTuple = tuple
                                showImagePicker = true
                            }) {
                                print("Tapped a connection")
                                receiverUUID = tuple.uuid
                                viewState = 2
                            }
                        }
                    }
                    HStack {
                        VStack {
                            JuliaTextField(label: "prompt", enteredText: $enteredText)
                                .transition(.push(from: .trailing))
                                .onSubmit {
                                    print(enteredText)
                                    if enteredText.lowercased() == "magic" {
                                        let authorization = CBCentralManager.authorization
                                        print("authorization: \(authorization)")
                                        if preferences.count < 1 {
                                            var newPreferences = Preferences(appPreferences: ["magical": enteredText], globalPreferences: [String: String]())
                                            
                                            Task(priority: .background) {
                                                do {
                                                    await Pref.createUser(preferences: newPreferences.appPreferences) { err, prefUser in
                                                        if let err = err {
                                                            print(err)
                                                            return
                                                        }
                                                        
                                                        guard let prefUser = prefUser else {
                                                            print("The problem is making prefUser in the first place")
                                                            return }
                                                        newPreferences.prefUUID = prefUser.uuid
                                                        print("prefUSer: \(prefUser)")
                                                        print("newPreferences: \(newPreferences)")
                                                        modelContext.insert(newPreferences)
                                                        try? modelContext.save()
                                                    }
                                                }
                                            }
                                        } else {
                                            let preferences = preferences[0]
                                            preferences.appPreferences["magical"] = enteredText
                                            modelContext.insert(preferences)
                                            try? modelContext.save()
                                            
                                            Task(priority: .background) {
                                                do {
                                                    let prefUser = PrefUser(uuid: preferences.prefUUID, preferences: preferences.appPreferences)
                                                    await Pref.savePreferences(prefUser: prefUser, newPreferences: prefUser.preferences) { err, prefUser in
                                                        print("ignore response here")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            /*JuliaButton(label: "enterPrompt") {
                                print("prompt is: \(enteredText)")
                                Task {
                                    await postPrompt()
                                }
                            }*/
                            if preferences.count > 0 && preferences[0].appPreferences["magical"] != nil {
                                GatewayButton {
                                    print("gateway it up")
                                    Task {
                                        do {
                                            await Julia.getPrompt(user: users[0]) { err, user in
                                                viewState = 5
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        .transition(.slide)
                        VStack {
                            JuliaButton(label: "getPrompt") {
                                print("get prompt tapped")
                                Task {
                                    await getPrompt()
                                }
                            }
                            .transition(.move(edge: .trailing))
                            if preferences.count > 0 && preferences[0].appPreferences["magical"] != nil {
                                SpellbookButton {
                                    print("magic it up")
                                    openSpellbook = true
                                }
                            }
                        }
                    }
                    Spacer()
                }
               // .background(.blue)
                .frame(width: 160, height: 48, alignment: .center)
                .position(x: w / 2, y: h * 0.55)
                VStack {
                   HStack {
                       Spacer()
                       Button(action: {
                           print("Pref button tapped!")
                           viewState = 7
                       }) {
                           Text("Pref")
                               .padding(8)
                               .background(.blue)
                               .foregroundColor(.white)
                               .cornerRadius(8)
                       }
                       .padding()
                   }
                   .padding(.top, 100)
                   .padding(.trailing, 100)
                   Spacer()
               }
           }
           .edgesIgnoringSafeArea(.all)
            .onAppear {
                let user = users[0]
                if user.keys.interactingKeys.count == 0 {
                    displayText = "noConnections"
                }
            }
            .sheet(isPresented: $showImagePicker) {
                UICircularImagePicker(image: $selectedImage)
            }
            .onChange(of: selectedImage) {
                if let image = selectedImage,
                   let tuple = selectedTuple {
                    var eightBitImage = EightBitImage(originalImagePath: "", image: image)
                    eightBitImage.saveImage()
                    preferences[0].appPreferences["\(tuple.uuid)Image"] = eightBitImage.filePath
                    modelContext.insert(preferences[0])
                    try? modelContext.save()
                    
                    Task(priority: .background) {
                        do {
                            let prefUser = PrefUser(uuid: preferences[0].prefUUID, preferences: preferences[0].appPreferences)
                            await Pref.savePreferences(prefUser: prefUser, newPreferences: prefUser.preferences) { err, prefUser in
                                print("ignore response here")
                            }
                        }
                    }
                }
            }
        }
    }
}
