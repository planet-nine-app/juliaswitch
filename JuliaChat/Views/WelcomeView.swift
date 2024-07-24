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
                        JuliaTextField(enteredText: $enteredText)
                        Text(LocalizedStringKey("handleHelpText"))
                            .frame(width: w - 128, height: 64, alignment: .center)
                            .padding(.all, 16)
                        JuliaButton(label: "letsGo") {
                            print("button pressed")
                            Task {
                                await Network.register(baseURL: "http://localhost:3000", handle: enteredText, callback: { err, data in
                                    if let err = err {
                                        print("error")
                                        print(err)
                                        return
                                    }
                                    guard let data = data else { return }
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
                                })
                            }
                        }
                        .background(.green)
                    }
                    .fixedSize()
                    .frame(width: w / 2, height: h * 0.75, alignment: .center)
                }
            }
        }
    }
}
