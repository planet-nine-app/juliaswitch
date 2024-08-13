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
    @State private var viewState = 1
    @State var receiverUUID = ""
    
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
        
        switch viewState {
        case 0: WelcomeView(viewState: $viewState)
            .onAppear {
            if users.count > 0 {
                let _ = print("there's a user now")
                let _ = print(users[0].uuid)
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
