package com.rudo.hybrid_stripe_payments

import com.rudo.hybrid_stripe_payments.channel.methods.WalletStripeMethodType
import com.rudo.hybrid_stripe_payments.core.stripe.StripeManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class HybridStripePaymentsPlugin : FlutterPlugin, MethodCallHandler {
    private var channel: MethodChannel? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        StripeManager.setApplicationContext(flutterPluginBinding.applicationContext)
        MethodChannel(flutterPluginBinding.binaryMessenger, "com.rudo/hybrid_stripe_payments").let {
            channel = it
            it.setMethodCallHandler(this)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        StripeManager.clearApplicationContext()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val method = WalletStripeMethodType.fromRawValue(call.method)
        if (method == null) {
            result.notImplemented()
            return
        }

        method.handle(call, result)
    }
}
