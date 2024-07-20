//
//  PlanetNineView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/17/24.
//

import SwiftUI

struct PlanetNineView: View {
    let backgroundImage = ImageResource(name: "space", bundle: Bundle.main)
    @State var displayText = "onboarding1"
    @State var onboardingState = 1
    @State var enteredText = ""
    let baseURL = "http://localhost:3000"
    
    func changeText() {
        if onboardingState >= 11 {
            return
        }
        onboardingState += 1
        displayText = "onboarding\(onboardingState)"
    }
    
    struct ExampleTextField: View {
        @Binding var enteredText: String
        
        var body: some View {
            TextField("Enter Text", text: $enteredText)
        }
    }
    
    struct CustomButtonStyle: ButtonStyle {
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .foregroundColor(.white)
                .cornerRadius(10)
                .opacity(configuration.isPressed ? 0.5 : 1)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            let _ = print(w)
            ZStack {
                Image(backgroundImage)
                
                VStack {
                    Text(LocalizedStringKey(displayText))
                        .font(.title3)
                        .foregroundStyle(.green)
                        .frame(width: w - 32, height: w - 32, alignment: .center)
                        .background(.black)
                        .clipShape(Circle())
                    
                    if onboardingState > 10 {
                        ExampleTextField(enteredText: $enteredText)
                            .frame(width: w - 128, height: 64, alignment: .center)
                            .background(.white)
                        Text(LocalizedStringKey("handleHelpText"))
                            .frame(width: w - 128, height: 64, alignment: .center)
                            .padding(.all, 16)
                        Button() {
                            print("button pressed")
                            Task {
                                await Network.register(baseURL: baseURL, handle: enteredText, callback: { err, data in
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
                                    } catch {
                                        print("Decoding failed ")
                                        print(error)
                                        return
                                    }
                                })
                            }
                        } label: {
                            Text(LocalizedStringKey("letsGo"))
                        }
                        .buttonStyle(CustomButtonStyle())
                        .background(.green)
                    }
                }
                .position(x: w / 2, y: 250)
            }
            .onTapGesture {
                changeText()
            }
        }
    }
}
