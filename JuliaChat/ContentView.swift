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
    
    func updateViewState(newState: Int) {
        viewState = newState
    }
    
    func viewForState(viewState: Int) -> any View {
        switch viewState {
        case 0: return WelcomeView() /*return Button("To 1", role: .none) {
            self.viewState += 1
        }*/
        case 1: return ConnectionsView()
            
        default: return Button("To 0", role: .none) {
            self.viewState = 0
        }
        }
    }

    var body: some View {
        
        switch viewState {
        case 0: WelcomeView()
            .onAppear {
            if users.count > 0 {
                let _ = print("there's a user now")
                let _ = print(users[0].uuid)
                let _ = updateViewState(newState: 1)
            }
        } /*return Button("To 1", role: .none) {
            self.viewState += 1
        }*/
        case 1: ConnectionsView()
                .task {
                    await Network.getUser(baseURL: "http://localhost:3000", user: users[0]) { err, data in
                        if let err = err {
                            print("ERORORORO")
                            print(err)
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
        .modelContainer(for: Message.self, inMemory: true)
        .modelContainer(for: User.self, inMemory: true)
}
