//
//  PaymentSwiftUIView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/8/24.
//

import SwiftUI
import SwiftData
import StripePaymentSheet

struct PaymentDialogStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 160, maxHeight: 60)
            .background(.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(   LinearGradient(
                        colors: [.blue, .orange, .blue],
                        startPoint: .top,
                        endPoint: .bottom),
                        lineWidth: 8)
                    )
                    .cornerRadius(24)
    }
}

class MyBackendModel: ObservableObject {
    
  @Published var paymentSheet: PaymentSheet?
  @Published var paymentResult: PaymentSheetResult?

    func preparePaymentSheet(uuid: String) {
    // MARK: Fetch the PaymentIntent and Customer information from the backend
      let uuid = uuid
      let timestamp = "".getTime()
      let amount = "2000"
      let currency = "usd"
      let sessionless = Sessionless()

      
      let message = "\(uuid)\(timestamp)\(amount)\(currency)"
      print(message)
      print(sessionless.getKeys()?.publicKey)
      guard let signature = sessionless.sign(message: message) else { return }

      guard let backendCheckoutUrl = URL(string: "http://localhost:3001/resolve/intent/user/\(uuid)?timestamp=\(timestamp)&amount=\(amount)&currency=\(currency)&signature=\(signature)") else { return }
      print("url: \(backendCheckoutUrl.absoluteString)")
      
    var request = URLRequest(url: backendCheckoutUrl)
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
      guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
            let customerId = json["customer"] as? String,
            let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
            let paymentIntentClientSecret = json["paymentIntent"] as? String,
            let publishableKey = json["publishableKey"] as? String,
            let self = self else {
        // Handle error
        return
      }
        
        print("past the guard")

      STPAPIClient.shared.publishableKey = publishableKey
        print("past key")
      // MARK: Create a PaymentSheet instance
      var configuration = PaymentSheet.Configuration()
      configuration.merchantDisplayName = "Concerts, Inc."
      configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
      // Set `allowsDelayedPaymentMethods` to true if your business can handle payment methods
      // that complete payment after a delay, like SEPA Debit and Sofort.
      configuration.allowsDelayedPaymentMethods = true
        print("Past configuration")

      DispatchQueue.main.async {
          print("dispatchin'")
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
      }
    })
    task.resume()
  }

  func onPaymentCompletion(result: PaymentSheetResult) {
      print("payment completed")
    self.paymentResult = result
  }
}

struct CheckoutView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var planetNineUsers: [PlanetNineUser]
  @ObservedObject var model = MyBackendModel()
    @Binding var viewState: Int

  var body: some View {
    VStack {
        let _ = print("paymentSheet? \(paymentSheet)")
      if let paymentSheet = model.paymentSheet {
          ZStack {
              PaymentSheet.PaymentButton(
                paymentSheet: paymentSheet,
                onCompletion: model.onPaymentCompletion
              ) {
                  Text("Buy")
              }
          }
          .modifier(PaymentDialogStyle())
      } else {
          ZStack {
              Text("Loading…")
          }
          .modifier(PaymentDialogStyle())

      }
      if let result = model.paymentResult {
          let _ = print("result exists")
          let _ = print(result)
        switch result {
        case .completed:
          Text("Payment complete")
                .onAppear {
                    viewState = 3
                }
        case .failed(let error):
          Text("Payment failed: \(error.localizedDescription)")
                .onAppear {
                    viewState = 3
                }
        case .canceled:
          Text("Payment canceled.")
                .onAppear {
                    viewState = 3
                }
        default:
            Text("Default")
                .onAppear {
                    viewState = 3
                }
        }
      }
    }.onAppear { model.preparePaymentSheet(uuid: planetNineUsers[0].uuid) }
  }
}
