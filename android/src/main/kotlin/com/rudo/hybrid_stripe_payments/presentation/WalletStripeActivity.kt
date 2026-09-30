package com.rudo.hybrid_stripe_payments.presentation
import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.Scaffold
import androidx.compose.ui.graphics.Color
import com.rudo.hybrid_stripe_payments.core.stripe.StripeManager
import com.stripe.android.paymentsheet.PaymentSheet
import com.stripe.android.paymentsheet.PaymentSheetResult

class WalletStripeActivity : ComponentActivity() {

    companion object {
        fun newIntent(context: Context): Intent = Intent(
                context,
                WalletStripeActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val paymentSheet = PaymentSheet.Builder(::handlePaymentSheetResult).build(this)

        runCatching {
            StripeManager.presentSheet(paymentSheet)
        }.onFailure {
            handlePaymentSheetResult(PaymentSheetResult.Canceled)
        }
    }

    private fun handlePaymentSheetResult(paymentSheetResult: PaymentSheetResult) {
        StripeManager.handlePaymentResult(paymentSheetResult)
        finish()
    }
}
