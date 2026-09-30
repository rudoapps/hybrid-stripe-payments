package com.rudo.hybrid_stripe_payments.channel.result

enum class WalletStripeResult(val rawValue: String) {
    COMPLETED("completed"),
    CANCELED("canceled");
}
