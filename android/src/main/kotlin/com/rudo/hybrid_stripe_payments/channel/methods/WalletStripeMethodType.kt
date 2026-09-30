package com.rudo.hybrid_stripe_payments.channel.methods

import com.rudo.hybrid_stripe_payments.core.stripe.StripePaymentSheetType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

enum class WalletStripeMethodType(val rawValue: String) {
    Initialize("initialize"),
    ShowPaymentSheet("showPaymentSheet"),
    ShowManageCreditCardsSheet("setupStripeSheet");

    fun handle(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (this) {
            Initialize -> WalletStripeInitHandler().handle(call, result)
            ShowPaymentSheet -> WalletStripeShowSheetHandler().handle(call, result, StripePaymentSheetType.PAYMENT)
            ShowManageCreditCardsSheet -> WalletStripeShowSheetHandler().handle(call, result, StripePaymentSheetType.SETUP)
        }
    }

    companion object {
        fun fromRawValue(method: String?): WalletStripeMethodType? {
            return entries.firstOrNull { it.rawValue == method }
        }
    }
}
