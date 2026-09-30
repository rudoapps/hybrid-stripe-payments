//
//  StripeError.swift
//
//
//  Created by Miguel Ángel Soto González on 27/10/25.
//

enum StripeError: Error {
    case notInitialized
    case viewControllerNotFound
}

extension StripeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notInitialized:
            return "StripeError.notInitized"
        case .viewControllerNotFound:
            return "StripeError.viewControllerNotFound"
        }
    }
}
