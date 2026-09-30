import 'package:hybrid_stripe_payments/src/domain/entity/keys/hybrid_stripe_payments_keys.dart';
import 'package:hybrid_stripe_payments/src/domain/entity/options/hybrid_stripe_payments_options.dart';
import 'package:hybrid_stripe_payments/src/domain/entity/result/hybrid_stripe_payments_result.dart';
import 'package:hybrid_stripe_payments/src/source/hybrid_stripe_payments_platform.dart';
import 'package:hybrid_stripe_payments/src/source/hybrid_stripe_payments.dart';

/// Entry point for the Hybrid Stripe Payments plugin.
///
/// Use [initialize] once at app startup, then call [showPaymentSheet] or
/// [setupStripeSheet] to present the corresponding Stripe sheet.
class HybridStripePaymentsImpl implements HybridStripePayments {
  /// Creates a new [HybridStripePaymentsImpl] instance.
  const HybridStripePaymentsImpl();

  /// Initializes the native Stripe SDK with the provided [options].
  ///
  /// Call this once before presenting any Stripe sheets.
  Future<void> initialize(HybridStripePaymentsOptions options) {
    return HybridStripePaymentsPlatform.instance.initialize(options);
  }

  /// Presents the Stripe PaymentSheet to collect a payment.
  ///
  /// - [keys]: Ephemeral credentials and intent details required for the
  ///   payment flow (e.g. PaymentIntent).
  /// - [buttonLabel]: Optional custom label for the confirmation button.
  ///
  /// Returns a [HybridStripePaymentsResult] indicating whether the user completed
  /// or canceled the flow.
  Future<HybridStripePaymentsResult> showPaymentSheet({
    required HybridStripePaymentsKeys keys,
    String? buttonLabel,
  }) {
    return HybridStripePaymentsPlatform.instance.showPaymentSheet(
      keys: keys,
      buttonLabel: buttonLabel,
    );
  }

  /// Presents the Stripe setup sheet to save a payment method.
  ///
  /// Typically uses a `SetupIntent` to attach a payment method to the
  /// customer without charging.
  ///
  /// - [keys]: Ephemeral credentials and intent details required for the
  ///   setup flow (e.g. SetupIntent).
  /// - [buttonLabel]: Optional custom label for the confirmation button.
  ///
  /// Returns a [HybridStripePaymentsResult] indicating whether the user completed
  /// or canceled the flow.
  Future<HybridStripePaymentsResult> setupStripeSheet({
    required HybridStripePaymentsKeys keys,
    String? buttonLabel,
  }) {
    return HybridStripePaymentsPlatform.instance.setupStripeSheet(
      keys: keys,
      buttonLabel: buttonLabel,
    );
  }
}
