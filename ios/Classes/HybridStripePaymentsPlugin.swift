import Flutter
import UIKit

public class HybridStripePaymentsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.rudo/hybrid_stripe_payments", binaryMessenger: registrar.messenger())
        let instance = HybridStripePaymentsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = WalletStripeMethodType(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
        method.handle(call, result: result)
    }
}
