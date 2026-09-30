//
//  WalletStripeInitHandler.swift
//
//
//  Created by Miguel Ángel Soto González on 20/10/25.
//

import Flutter

class WalletStripeInitHandler {
    let stripe: StripeManagerProtocol

    init(stripe: StripeManagerProtocol = StripeManager.shared) {
        self.stripe = stripe
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let options = arguments["options"] as? [String: Any],
              let publishableKey = options["publishableKey"] as? String,
              let merchantName = options["merchantName"] as? String
        else {
            let error = WalletStripeError.missingArgument(method: WalletStripeMethodType.initialize.rawValue)
            result(error.rawValue)
            return
        }

        let allowsDelayedPaymentMethods = options["allowsDelayedPaymentMethods"] as? Bool ?? false
        let primaryButtonColorHex = options["primaryButtonColor"] as? Int

        stripe.initialize(publishableKey: publishableKey,
                          merchantName: merchantName,
                          allowsDelayedPaymentMethods: allowsDelayedPaymentMethods,
                          primaryButtonColorHex: primaryButtonColorHex)
        result(nil)
    }
}
