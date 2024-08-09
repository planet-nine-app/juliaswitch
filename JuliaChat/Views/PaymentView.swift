import UIKit
import SwiftUI
import SwiftData
import StripePaymentSheet

struct StripeBottomSheet: UIViewControllerRepresentable {
    @Environment(\.modelContext) var modelContext
    @Query private var planetNineUsers: [PlanetNineUser]
    typealias UIViewType = UIView
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = CheckoutViewController()
        vc.uuid = planetNineUsers[0].uuid
        return vc
    }
    
    func makeCoordinator() -> () {
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

class CheckoutViewController: UIViewController {
    let checkoutButton = UIButton()
  var paymentSheet: PaymentSheet?
    var uuid: String!
    var backendCheckoutUrl: URL!  // Your backend endpoint
    let sessionless = Sessionless()

  override func viewDidLoad() {
    super.viewDidLoad()
      view.backgroundColor = .blue
      
      guard let uuid = uuid else { return }
      let timestamp = "".getTime()
      let amount = "2000"
      let currency = "usd"
      
      let message = "\(uuid)\(timestamp)\(amount)\(currency)"
      print(message)
      print(sessionless.getKeys()?.publicKey)
      guard let signature = sessionless.sign(message: message) else { return }

      guard let backendCheckoutUrl = URL(string: "http://localhost:3001/resolve/intent/user/\(uuid)?timestamp=\(timestamp)&amount=\(amount)&currency=\(currency)&signature=\(signature)") else { return }
      print("url: \(backendCheckoutUrl.absoluteString)")
      
    checkoutButton.addTarget(self, action: #selector(didTapCheckoutButton), for: .touchUpInside)
    checkoutButton.isEnabled = false
      checkoutButton.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(checkoutButton)
      checkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      checkoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      checkoutButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
      checkoutButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
      checkoutButton.setTitle("HEYOOOOOO", for: .normal)

    // MARK: Fetch the PaymentIntent client secret, Ephemeral Key secret, Customer ID, and publishable key
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

      STPAPIClient.shared.publishableKey = publishableKey
      // MARK: Create a PaymentSheet instance
      var configuration = PaymentSheet.Configuration()
      configuration.merchantDisplayName = "Example, Inc."
      configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
      // Set `allowsDelayedPaymentMethods` to true if your business handles
      // delayed notification payment methods like US bank accounts.
      configuration.allowsDelayedPaymentMethods = true
      self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)

      DispatchQueue.main.async {
        self.checkoutButton.isEnabled = true
      }
    })
    task.resume()
  }
    
    @objc func didTapCheckoutButton() {
        print("tapCheckout Button")
        // MARK: Start the checkout process
          paymentSheet?.present(from: self) { paymentResult in
            // MARK: Handle the payment result
            switch paymentResult {
            case .completed:
              print("Your order is confirmed")
            case .canceled:
              print("Canceled!")
            case .failed(let error):
              print("Payment failed: \(error)")
            }
        }
    }

}
