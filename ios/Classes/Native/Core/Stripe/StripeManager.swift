//
//  StripeManager.swift
//
//
//  Created by Miguel Ángel Soto González on 20/10/25.
//

import Foundation
import StripePaymentSheet
import UIKit

class StripeManager: StripeManagerProtocol {
    static let shared = StripeManager()

    // MARK: - Properties
    private var merchantName: String?
    private var allowsDelayedPaymentMethods: Bool = false
    private var primaryButtonColor: UIColor = .black

    // MARK: - Functions
    func initialize(
        publishableKey: String,
        merchantName: String,
        allowsDelayedPaymentMethods: Bool,
        primaryButtonColorHex: Int?
    ) {
        self.merchantName = merchantName
        self.allowsDelayedPaymentMethods = allowsDelayedPaymentMethods
        if let primaryButtonColorHex {
            primaryButtonColor = UIColor.fromARGB(primaryButtonColorHex)
        } else {
            primaryButtonColor = .black
        }
        STPAPIClient.shared.publishableKey = publishableKey
    }

    @MainActor
    func showPaymentIntentSheet(stripeKeys: StripeKeys,
                                buttonLabel: String?,
                                completion: @escaping (PaymentSheetResult) -> Void) async throws {
        let configuration = try getSheetConfiguration(with: stripeKeys, buttonLabel: buttonLabel)
        let sheet = PaymentSheet(
            paymentIntentClientSecret: stripeKeys.intentSecret,
            configuration: configuration
        )

        guard let viewController = getTopViewController() else {
            throw StripeError.viewControllerNotFound
        }

        sheet.present(from: viewController, completion: completion)
    }

    @MainActor
    func showManageCreditCardsSheet(stripeKeys: StripeKeys,
                                    buttonLabel: String?,
                                    completion: @escaping (PaymentSheetResult) -> Void) async throws {
        let configuration = try getSheetConfiguration(with: stripeKeys, buttonLabel: buttonLabel)
        let sheet = PaymentSheet(
            setupIntentClientSecret: stripeKeys.intentSecret,
            configuration: configuration
        )

        guard let viewController = getTopViewController() else {
            throw StripeError.viewControllerNotFound
        }

        sheet.present(from: viewController, completion: completion)
    }

    private func getSheetConfiguration(
        with keys: StripeKeys,
        buttonLabel: String? = nil
    ) throws -> PaymentSheet.Configuration {
        guard let merchantName else {
            throw StripeError.notInitialized
        }

        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = merchantName
        configuration.allowsDelayedPaymentMethods = allowsDelayedPaymentMethods
        configuration.primaryButtonLabel = buttonLabel

        configuration.appearance.primaryButton.backgroundColor = primaryButtonColor

        configuration.customer = .init(id: keys.customerID, ephemeralKeySecret: keys.ephemeralKey)

        return configuration
    }

    private func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

        guard var topViewController = keyWindow?.rootViewController else {
            return nil
        }

        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }

        return topViewController
    }
}

private extension UIColor {
    static func fromARGB(_ argb: Int) -> UIColor {
        let value = UInt32(bitPattern: Int32(truncatingIfNeeded: argb))
        let alpha = CGFloat((value >> 24) & 0xFF) / 255.0
        let red = CGFloat((value >> 16) & 0xFF) / 255.0
        let green = CGFloat((value >> 8) & 0xFF) / 255.0
        let blue = CGFloat(value & 0xFF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
