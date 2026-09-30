package com.rudo.hybrid_stripe_payments.channel.methods

import com.rudo.hybrid_stripe_payments.channel.error.WalletStripeError
import com.rudo.hybrid_stripe_payments.channel.result.WalletStripeResult
import com.rudo.hybrid_stripe_payments.core.stripe.StripeConfigKeys
import com.rudo.hybrid_stripe_payments.core.stripe.StripeManager
import com.rudo.hybrid_stripe_payments.core.stripe.StripeManagerInterface
import com.rudo.hybrid_stripe_payments.core.stripe.StripePaymentSheetType
import com.stripe.android.paymentsheet.PaymentSheetResult
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.collections.get

class WalletStripeShowSheetHandler(
    private val stripeManager: StripeManagerInterface = StripeManager
)  {

    private companion object {
        const val KEYS = "keys"
        const val CUSTOMER_ID = "customerId"
        const val EPHEMERAL_KEY = "ephemeralKey"
        const val INTENT_ID = "intentId"
        const val CLIENT_SECRET = "clientSecret"
        const val BUTTON_LABEL = "buttonLabel"
    }

    fun handle(call: MethodCall, result: Result, type: StripePaymentSheetType) {
        val arguments = call.arguments as? Map<*, *>
        val keys = getStripeKeys(arguments)

        if (keys == null) {
            val walletError = WalletStripeError.MissingArgument(WalletStripeMethodType.ShowManageCreditCardsSheet.rawValue,)
            result.error(walletError.code(), walletError.message(), walletError.details())
            return
        }

        val buttonLabel = arguments?.get(BUTTON_LABEL) as? String
        try {
            stripeManager.showSheet(
                keys = keys,
                type = type,
                buttonLabel = buttonLabel
            ) { paymentResult ->
                handleResult(result, paymentResult)
            }
        } catch (throwable: Throwable) {
            val walletError = WalletStripeError.Standard(throwable.message)
            result.error(walletError.code(), walletError.message(), walletError.details())
        }
    }

    fun handleResult(result: Result, paymentResult: PaymentSheetResult) {
        when (paymentResult) {
            is PaymentSheetResult.Completed -> result.success(WalletStripeResult.COMPLETED.rawValue)
            is PaymentSheetResult.Canceled -> result.success(WalletStripeResult.CANCELED.rawValue)
            is PaymentSheetResult.Failed -> {
                val walletError = WalletStripeError.Standard(paymentResult.error.message)
                result.error(walletError.code(), walletError.message(), walletError.details())
            }
        }
    }

    fun getStripeKeys(arguments: Map<*, *>?) : StripeConfigKeys? {
        val keysArgument = arguments?.get(KEYS) as? Map<*, *>

        val customerId = keysArgument?.get(CUSTOMER_ID) as? String
        val ephemeralKey = keysArgument?.get(EPHEMERAL_KEY) as? String
        val intentId = keysArgument?.get(INTENT_ID) as? String
        val clientSecret = keysArgument?.get(CLIENT_SECRET) as? String

        if (customerId == null ||
            ephemeralKey == null ||
            intentId == null ||
            clientSecret == null
        ) {
            return null
        }

        return StripeConfigKeys(
            customerId = customerId,
            ephemeralKey = ephemeralKey,
            intentId = intentId,
            intentSecret = clientSecret
        )
    }
}
