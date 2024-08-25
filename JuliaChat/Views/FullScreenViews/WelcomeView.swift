//
//  WelcomeView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/17/24.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State var displayText = "onboarding1"
    @State var onboardingState = 1
    @State var enteredText = ""
    @Binding var viewState: Int
    
    func changeText() {
        if onboardingState >= 11 {
            return
        }
        onboardingState += 1
        displayText = "onboarding\(onboardingState)"
        print(onboardingState)
    }

    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            ZStack {
                PlanetNineView(displayText: $displayText)
                    .onTapGesture {
                        changeText()
                    }
                
                if onboardingState > 10 {
                    VStack {
                        JuliaTextField(label: "handle", enteredText: $enteredText)
                        Text(LocalizedStringKey("handleHelpText"))
                            .frame(width: w - 128, height: 64, alignment: .center)
                            .padding(.all, 16)
                        JuliaButton(label: "letsGo") {
                            print("button pressed")
                            Task {
                                let preference = Preferences(appPreferences: [String: String](), globalPreferences: [String: String]())
                                modelContext.insert(preference)
                                try? modelContext.save()
                                await Julia.createUser(handle: enteredText) { err, user in
                                    if let err = err {
                                        return
                                    }
                                    guard let user = user else { return }
                                    
                                    modelContext.insert(user)
                                    try? modelContext.save()
                                    viewState = 1
                                }
                            }
                        }
                        .background(.green)
                    }
                    .fixedSize()
                    .frame(width: w / 2, height: h * 0.75, alignment: .center)
                }
            }
        //    .contentShape(Rectangle())
        //    .background(.blue)
        }
    }
}
