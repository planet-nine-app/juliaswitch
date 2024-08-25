//
//  PrefView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/24/24.
//

import SwiftUI
import SwiftData

struct PrefView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var users: [User]
    
    @Binding var viewState: Int
    
    let backgroundImage = ImageResource(name: "space", bundle: Bundle.main)
    
    func clearAllSwiftData() {
            // 1. Get all model types in your app
        let modelTypes: [any PersistentModel.Type] = [
                User.self,
                PlanetNineUser.self,
                Preferences.self
                // Add all other model types here
            ]
        
        let userDescriptor = FetchDescriptor<User>(predicate: nil)
        let planetNineUserDescriptor = FetchDescriptor<PlanetNineUser>(predicate: nil)
        let preferencesDescriptor = FetchDescriptor<Preferences>(predicate: nil)
        
        let users = try? modelContext.fetch(userDescriptor)
        let planetNineUsers = try? modelContext.fetch(planetNineUserDescriptor)
        let preferences = try? modelContext.fetch(preferencesDescriptor)
        
        if let users = users {
            for user in users {
                modelContext.delete(user)
            }
        }
        
        if let planetNineUsers = planetNineUsers {
            for planetNineUser in planetNineUsers {
                modelContext.delete(planetNineUser)
            }
        }
        
        if let preferences = preferences {
            for preference in preferences {
                modelContext.delete(preference)
            }
        }
        
            
           
            
            // 3. Save changes
            do {
                try modelContext.save()
                print("All SwiftData cleared successfully")
            } catch {
                print("Failed to save after clearing data: \(error)")
            }
        }
    
    var body: some View {
        ZStack {
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            JuliaButton(label: "eject") {
                Task {
                    do {
                        await Julia.deleteJuliaUser(user: users[0])
                        { error, data in
                            
                            clearAllSwiftData()
                            viewState = 0
                        }
                    }
                }
            }
        }
    }
}
