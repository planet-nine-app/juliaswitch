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
    //@Query private var user: User
    @State private var viewState = 0
    
    func viewForState(viewState: Int) -> any View {
        switch viewState {
        case 0: return WelcomeView() /*return Button("To 1", role: .none) {
            self.viewState += 1
        }*/
        case 1: return Button("To 2", role: .none) {
            self.viewState += 2
        }
        default: return Button("To 0", role: .none) {
            self.viewState = 0
        }
        }
    }

    var body: some View {
        switch viewState {
        case 0: WelcomeView() /*return Button("To 1", role: .none) {
            self.viewState += 1
        }*/
        case 1: Button("To 2", role: .none) {
            self.viewState += 2
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
        .modelContainer(for: Item.self, inMemory: true)
}
