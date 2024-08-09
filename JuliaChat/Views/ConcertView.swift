//
//  ChatView.swift
//  JuliaChat
//
//  Created by Zach Babb on 7/17/24.
//

import SwiftUI
import SwiftData

struct ConcertView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var users: [User]
    
    func randomFutureDateTime() -> [String: Int] {
        let start = (Int("".getTime()) ?? 0) + Int.random(in: 0..<6000000)
        let end = start + Int.random(in: 60000..<120000)
        return [
            "startDateTime": start,
            "endDateTime": end
        ]
    }

    let popups = [
        Popup(name: "Dragonforce", dateTimes: [["startDateTime": 1723178413695, "endDateTime": 1723178495279]], location: "Crystal Ballroom", description: "Hear the kings of shred take care of business. 🤘", imageId: "foo"),
            Popup(name: "Erotic City Prince Tribute Band", dateTimes: [["startDateTime": 1723178481434, "endDateTime": 1723178487025]], location: "My Father's Place", description: "Things might get a little weird, but it'll be fun. ☔️", imageId: "foo2"),
            Popup(name: "Pink Martini", dateTimes: [["startDateTime": 1723178632425, "endDateTime": 1723178968085]], location: "The Schnitz", description: "Come join us on our 30th anniversary tour! 🩷🍸", imageId: "foo3")
        
    ]
    
    let backgroundImage = ImageResource(name: "space", bundle: Bundle.main)
    @State var enteredText = ""
    @State var popupChosen = false
    @State var chosenPopup = Popup(name: "foo", dateTimes: [[String: Int]](), location: "bar", description: "baz", imageId: "bop")
    @Binding var viewState: Int
    @Binding var receiverUUID: String
    
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
            
            ZStack {
                Image(backgroundImage)
                
                VStack {
                    VStack {
                        List(popups) { popup in
                            //DialogBoxView(content: popup)
                            ConcertDialogView(popup: popup, popupChosen: $popupChosen, chosenPopup: $chosenPopup)
                        }
                    }
                    Spacer()
                    //Text("FOO")
                    HStack {
                        DialogBoxTextFieldView(enteredText: $enteredText)
                        JuliaButton(label: "Send") {
                            Task {
                                await Network.sendMessage(baseURL: "http://localhost:3000", user: users[0], content: enteredText, receiverUUID: receiverUUID) { err, data in
                                    if let err = err {
                                        print("EROROROR")
                                        print(err)
                                        return
                                    }
                                    if let data = data {
                                        print("Maybe success")
                                        print(String(data: data, encoding: .utf8))
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .frame(width: w, height: h)
                .background(.blue)
            }
            .frame(width: w, height: h)
            if popupChosen {
               CheckoutView()
            }
        }
    }
}
