package com.rudo.hybrid_stripe_payments.core.stripe

import android.content.res.ColorStateList
import com.rudo.hybrid_stripe_payments.presentation.WalletStripeActivity
import com.stripe.android.PaymentConfiguration
import com.stripe.android.paymentsheet.PaymentSheet
import com.stripe.android.paymentsheet.PaymentSheetResult
import android.content.Context

object StripeManager : StripeManagerInterface {
    private var applicationContext: Context? = null
    private var merchantName: String? = null
    private var allowsDelayedPaymentMethods: Boolean = false
    private var primaryButtonColor: ColorStateList? = null

    private var paymentType: StripePaymentSheetType? = null
    private var keys: StripeConfigKeys? = null
    private var buttonLabel: String? = null
    private var onPaymentCompleted: (PaymentSheetResult) -> Unit = {}

    override fun setApplicationContext(context: Context) {
        applicationContext = context.applicationContext
    }

    override fun clearApplicationContext() {
        applicationContext = null
    }

    override fun initialize(
        publishableKey: String,
        merchantName: String,
        allowsDelayedPaymentMethods: Boolean,
        primaryButtonColor: Int?
    ) {
        this.merchantName = merchantName
        this.allowsDelayedPaymentMethods = allowsDelayedPaymentMethods
        this.primaryButtonColor = primaryButtonColor?.let { ColorStateList.valueOf(primaryButtonColor) }

        val context = applicationContext
        if (context == null) {
            throw StripeError.ContextNotFound
        } else {
            PaymentConfiguration.init(context, publishableKey)
        }
    }

    override fun showSheet(
        keys: StripeConfigKeys,
        buttonLabel: String?,
        type: StripePaymentSheetType,
        onPaymentCompleted: (PaymentSheetResult) -> Unit
    ) {
        val context = applicationContext

        if (merchantName == null) {
            throw StripeError.NotInitialized
        }

        this.paymentType = type
        this.keys = keys
        this.onPaymentCompleted = onPaymentCompleted
        this.buttonLabel = buttonLabel

        if (context == null) {
            throw StripeError.ContextNotFound
        } else {
            val intent = WalletStripeActivity.newIntent(context)
            context.startActivity(intent)
        }
    }

    override fun presentSheet(paymentSheet: PaymentSheet) {
        val keys = keys

        if (keys == null) {
            throw StripeError.MissingKeys
        } else {
            val configuration = getSheetConfiguration(keys)

            paymentType?.let {
                when(it) {
                    StripePaymentSheetType.PAYMENT -> paymentSheet.presentWithPaymentIntent(keys.intentSecret, configuration)
                    StripePaymentSheetType.SETUP -> paymentSheet.presentWithSetupIntent(keys.intentSecret, configuration)
                }
            }
        }
    }

    override fun handlePaymentResult(result: PaymentSheetResult) {
        onPaymentCompleted(result)
    }

    private fun getSheetConfiguration(keys: StripeConfigKeys): PaymentSheet.Configuration {
        val merchantName = merchantName

        if (merchantName == null) {
            throw StripeError.NotInitialized
        } else {
            return PaymentSheet.Configuration(
                customer = PaymentSheet.CustomerConfiguration(
                    id = keys.customerId,
                    ephemeralKeySecret = keys.ephemeralKey
                ),
                primaryButtonLabel = buttonLabel,
                merchantDisplayName = merchantName,
                primaryButtonColor = primaryButtonColor,
                allowsDelayedPaymentMethods = allowsDelayedPaymentMethods
            )
        }
    }
}
