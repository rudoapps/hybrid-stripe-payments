package com.rudo.hybrid_stripe_payments.channel.methods

import com.rudo.hybrid_stripe_payments.channel.error.WalletStripeError
import com.rudo.hybrid_stripe_payments.core.stripe.StripeManager
import com.rudo.hybrid_stripe_payments.core.stripe.StripeManagerInterface
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.collections.get

class WalletStripeInitHandler(
    private val stripeManager: StripeManagerInterface = StripeManager
)  {

    private companion object {
        const val OPTIONS = "options"
        const val PUBLISHABLE_KEY = "publishableKey"
        const val MERCHANT_NAME = "merchantName"
        const val ALLOWS_DELAYED_PAYMENT_METHODS = "allowsDelayedPaymentMethods"
        const val PRIMARY_BUTTON_COLOR = "primaryButtonColor"

    }

    fun handle(call: MethodCall, result: Result) {
        val arguments = call.arguments as? Map<*, *>
        val options = arguments?.get(OPTIONS) as? Map<*, *>

        val publishableKey = options?.get(PUBLISHABLE_KEY) as? String
        val merchantName = options?.get(MERCHANT_NAME) as? String

        if (publishableKey == null || merchantName == null) {
            val walletError = WalletStripeError.MissingArgument(WalletStripeMethodType.Initialize.rawValue)
            result.error(walletError.code(), walletError.message(), walletError.details())
            return
        }

        val allowsDelayedPaymentMethods = options[ALLOWS_DELAYED_PAYMENT_METHODS] as? Boolean ?: false
        val primaryButtonColor = (options[PRIMARY_BUTTON_COLOR] as? Number)?.toInt()

        stripeManager.initialize(
            publishableKey = publishableKey,
            merchantName = merchantName,
            allowsDelayedPaymentMethods = allowsDelayedPaymentMethods,
            primaryButtonColor = primaryButtonColor
        )

        result.success(null)
    }
}
