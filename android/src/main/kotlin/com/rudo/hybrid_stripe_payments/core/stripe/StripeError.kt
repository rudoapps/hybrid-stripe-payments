package com.rudo.hybrid_stripe_payments.core.stripe

sealed class StripeError(message: String? = null): Exception(message) {
    object NotInitialized: StripeError("StripeError.notInitialized")
    object ContextNotFound: StripeError("StripeError.contextNotFound")
    object MissingKeys: StripeError("StripeError.missingKeys")

}