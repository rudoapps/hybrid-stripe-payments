//
//  WalletStripeError.swift
//
//
//  Created by Miguel Ángel Soto González on 20/10/25.
//

import Flutter

enum WalletStripeError {
    case standard(details: String)
    case missingArgument(method: String)

    var rawValue: FlutterError {
        switch self {
        case .standard(let details):
            return FlutterError(
                code: "UNKNOWN",
                message: "Unknown Error",
                details: details
            )
        case .missingArgument(let method):
            return FlutterError(
                code: "MISSING_ARGUMENTS",
                message: "Missing Argument",
                details: "A required argument is missing from the method \(method)"
            )
        }
    }
}
