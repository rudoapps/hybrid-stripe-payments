//
//  WalletStripeShowPaymentSheetHandler.swift
//
//
//  Created by Miguel Ángel Soto González on 20/10/25.
//

import Flutter

class WalletStripeShowPaymentSheetHandler {
    let stripe: StripeManagerProtocol

    init(stripe: StripeManagerProtocol = StripeManager.shared) {
        self.stripe = stripe
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let keys = arguments["keys"] as? [String: Any],
              let customerID = keys["customerId"] as? String,
              let ephemeralKey = keys["ephemeralKey"] as? String,
              let type = keys["type"] as? String,
              let intentID = keys["intentId"] as? String,
              let clientSecret = keys["clientSecret"] as? String
        else {
            let error = WalletStripeError.missingArgument(method: WalletStripeMethodType.initialize.rawValue)
            result(error.rawValue)
            return
        }

        Task {
            do {
                let keys = StripeKeys(
                    customerID: customerID,
                    ephemeralKey: ephemeralKey,
                    type: type,
                    intentID: intentID,
                    intentSecret: clientSecret)

                let buttonLabel = arguments["buttonLabel"] as? String
                try await stripe.showPaymentIntentSheet(stripeKeys: keys, buttonLabel: buttonLabel) { paymentResult in
                    switch paymentResult {
                    case .completed:
                        result(WalletStripeResult.completed.rawValue)
                    case .canceled:
                        result(WalletStripeResult.canceled.rawValue)
                    case .failed(let error):
                        let channelError = WalletStripeError.standard(details: error.localizedDescription)
                        result(channelError.rawValue)
                    }
                }
            } catch {
                let channelError = WalletStripeError.standard(details: error.localizedDescription)
                result(channelError.rawValue)
            }
        }
    }
}
