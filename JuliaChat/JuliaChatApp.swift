//
//  JuliaChatApp.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/12/24.
//

import SwiftUI
import SwiftData

@main
struct JuliaChatApp: App {
    let sharedModelContainer: ModelContainer
    init() {
        let schema = Schema([
//            KeyTuple.self,
//            AssociatedKeys.self,
            Message.self,
            Prompt.self,
            User.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
