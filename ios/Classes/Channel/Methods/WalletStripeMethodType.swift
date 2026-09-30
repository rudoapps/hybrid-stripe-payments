//
//  WalletStripeMethodType.swift
//
//
//  Created by Miguel Ángel Soto González on 20/10/25.
//

import Flutter

enum WalletStripeMethodType: String {
    case initialize
    case showPaymentSheet
    case showManageCreditCardsSheet = "setupStripeSheet"

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch self {
        case .initialize:
            return WalletStripeInitHandler().handle(call, result: result)
        case .showPaymentSheet:
            return WalletStripeShowPaymentSheetHandler().handle(call, result: result)
        case .showManageCreditCardsSheet:
            return WalletStripeShowManageCreditCardSheetHandler().handle(call, result: result)
        }
    }
}
