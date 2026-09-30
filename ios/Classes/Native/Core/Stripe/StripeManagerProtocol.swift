//
//  StripeManagerProtocol.swift
//
//
//  Created by Miguel Ángel Soto González on 20/10/25.
//

import StripePaymentSheet

protocol StripeManagerProtocol {
    func initialize(publishableKey: String,
                    merchantName: String,
                    allowsDelayedPaymentMethods: Bool,
                    primaryButtonColorHex: Int?)
    func showPaymentIntentSheet(stripeKeys: StripeKeys,
                                buttonLabel: String?,
                                completion: @escaping (PaymentSheetResult) -> Void) async throws
    func showManageCreditCardsSheet(stripeKeys: StripeKeys,
                                    buttonLabel: String?,
                                    completion: @escaping (PaymentSheetResult) -> Void) async throws
}
