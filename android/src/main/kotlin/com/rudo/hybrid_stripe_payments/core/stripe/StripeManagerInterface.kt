package com.rudo.hybrid_stripe_payments.core.stripe

import android.content.Context
import com.stripe.android.paymentsheet.PaymentSheet
import com.stripe.android.paymentsheet.PaymentSheetResult

interface StripeManagerInterface {
    fun initialize(
        publishableKey: String,
        merchantName: String,
        allowsDelayedPaymentMethods: Boolean,
        primaryButtonColor: Int?
    )

    fun showSheet(
        keys: StripeConfigKeys,
        buttonLabel: String?,
        type: StripePaymentSheetType,
        onPaymentCompleted: (PaymentSheetResult) -> Unit
    )

    fun setApplicationContext(context: Context)
    fun clearApplicationContext()
    fun presentSheet(paymentSheet: PaymentSheet)
    fun handlePaymentResult(result: PaymentSheetResult)
}
