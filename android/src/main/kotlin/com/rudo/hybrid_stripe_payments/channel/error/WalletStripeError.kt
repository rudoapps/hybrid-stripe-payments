package com.rudo.hybrid_stripe_payments.channel.error

sealed class WalletStripeError {
    data class Standard(val details: String?) : WalletStripeError()
    data class MissingArgument(val method: String) : WalletStripeError()

    fun code(): String {
        return when (this) {
            is Standard -> "UNKNOWN"
            is MissingArgument -> "MISSING_ARGUMENTS"
        }
    }

    fun message(): String {
        return when (this) {
            is Standard -> "Unknown Error"
            is MissingArgument -> "Missing Argument"
        }
    }

    fun details(): String {
        return when (this) {
            is Standard -> details ?: "-"
            is MissingArgument -> "A required argument is missing from the method $method"
        }
    }
}
