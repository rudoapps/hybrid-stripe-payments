package com.rudo.hybrid_stripe_payments.core.stripe

data class StripeConfigKeys(
    val customerId: String,
    val ephemeralKey: String,
    val intentId: String,
    val intentSecret: String
)
