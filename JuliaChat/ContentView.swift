//
//  ContentView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/12/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @State private var viewState = 0
    @State var receiverUUID = ""
    @State var log = "start..."
    
    func updateViewState(newState: Int) {
        viewState = newState
    }
    
    func viewForState(viewState: Int) -> any View {
        switch viewState {
        case 0: return WelcomeView(viewState: $viewState) /*return Button("To 1", role: .none) {
            self.viewState += 1
        }*/
        case 1: return ConnectionsView(viewState: $viewState, receiverUUID: $receiverUUID)
        case 2: return ChatView(viewState: $viewState, receiverUUID: $receiverUUID)
            
        default: return Button("To 0", role: .none) {
            self.viewState = 0
        }
        }
    }

    var body: some View {
        let _ = print("switching to viewState \(viewState)")
        switch viewState {
        case 0: WelcomeView(viewState: $viewState)
            .onAppear {
            if users.count > 0 {
                let _ = print("there's a user now")
                let _ = print(users[0].juliaUUID)
                let _ = updateViewState(newState: 1)
            }
        } /*return Button("To 1", role: .none) {
            self.viewState += 1
        }*/
        case 1: ConnectionsView(viewState: $viewState, receiverUUID: $receiverUUID)
                .task {
                    await Julia.syncKeys(user: users[0]) { err, user in
                        if let err = err {
                            print("Oh noooo!")
                            return
                        }
                        guard let user = user else { return }
                        modelContext.insert(user)
                        try? modelContext.save()
                    }
                }
        case 2: ChatView(viewState: $viewState, receiverUUID: $receiverUUID)
            //StripeBottomSheet()
        case 3: ImagePickerView()
        case 4: CasterView(log: $log, readCallback: { value in
            log = "\(log)\nreceived gateway value: \(value)"
            print("received gateway value: \(value)")
            //Task {
                do {
                    await Julia.postPrompt(user: users[0], prompt: value) { err, user in
                        log = "\(log)\nthe callback happens"
                        print("the callback happens")
                    }
                }
            //}
            log = "\(log)\nand then the spell I hope"
            print("and then the spell I hope")
            return Spell()
        }, spellCastCallback: {
            log = "\(log)\ncast spell"
            print("cast spell")
        }, notifyCallback: { value in
            log = "\(log)\nnotification value: \(value)"
            print("notification value: \(value)")
        }, spellName: "connect")
        case 5: GatewayView(log: $log, readRequestCallback: {
            return users[0].mostRecentPrompt() ?? ""
        }, spellReceivedCallback: { spell in
            log = "\(log)\ngot spell: \(spell.toString())"
            print("got spell: \(spell.toString())")
            Task {
                do {
                    await Julia.syncKeys(user: users[0]) { err, user in
                        if let user = user {
                            modelContext.insert(user)
                            try? modelContext.save()
                            
                            Task {
                                do {
                                    let updatedUser = users[0]
                                    guard let mostRecentSignedPrompt = updatedUser.mostRecentSignedPrompt(),
                                          let prompt = updatedUser.pendingPrompts[mostRecentSignedPrompt] else { return }
                                    log = "\(log)\nsignedPrompt signature: \(prompt.newSignature)"
                                    let postPrompt = PostPrompt(timestamp: prompt.newTimestamp ?? "", uuid: prompt.newUUID ?? "", pubKey: prompt.newPubKey ?? "", prompt: prompt.prompt ?? "", signature: prompt.newSignature ?? "")
                                    log = "\(log)\ntrying to associate \(postPrompt)"
                                    await Julia.associate(user: users[0], signedPrompt: postPrompt) { err, user in
                                        log = "\(log)\nAssociated!"
                                        print("Associated!")
                                        if let user = user {
                                            modelContext.insert(user)
                                            try? modelContext.save()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
        case 6: Text("hello world")
        case 9: CircularImagePicker(viewState: $viewState)
        default: Button("To 0", role: .none) {
            self.viewState = 0
        }
        }
    }

}

#Preview {
    ContentView()
        .environment(\.locale, .init(identifier: "en"))
        /*
         .modelContainer(for: KeyTuple.self, inMemory: true)
        .modelContainer(for: AssociatedKeys.self, inMemory: true)*/
        .modelContainer(for: User.self, inMemory: true)
}
