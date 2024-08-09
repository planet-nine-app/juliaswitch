//
//  PaymentSwiftUIView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/8/24.
//

import SwiftUI
import SwiftData
import StripePaymentSheet

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
    self.paymentResult = result
  }
}

struct CheckoutView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var planetNineUsers: [PlanetNineUser]
  @ObservedObject var model = MyBackendModel()

  var body: some View {
    VStack {
        let _ = print("paymentSheet? \(paymentSheet)")
      if let paymentSheet = model.paymentSheet {
        PaymentSheet.PaymentButton(
          paymentSheet: paymentSheet,
          onCompletion: model.onPaymentCompletion
        ) {
          Text("Buy")
        }
      } else {
        Text("Loading…")
      }
      if let result = model.paymentResult {
        switch result {
        case .completed:
          Text("Payment complete")
        case .failed(let error):
          Text("Payment failed: \(error.localizedDescription)")
        case .canceled:
          Text("Payment canceled.")
        }
      }
    }.onAppear { model.preparePaymentSheet(uuid: planetNineUsers[0].uuid) }
  }
}
