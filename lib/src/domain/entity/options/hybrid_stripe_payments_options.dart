import 'package:flutter/widgets.dart';

/// Configuration options used to initialize the native Stripe SDK.
class HybridStripePaymentsOptions {
  /// The Stripe publishable key (e.g. `pk_live_xxx` or `pk_test_xxx`).
  final String publishableKey;

  /// The merchant display name shown in the payment sheet.
  final String merchantName;

  /// The primary color used for the confirmation button in the payment sheet.
  final Color primaryButtonColor;

  /// Whether to allow payment methods that notify you of a successful payment
  /// after some delay (e.g. SEPA Debit, Sofort).
  final bool allowsDelayedPaymentMethods;

  /// Creates a new [HybridStripePaymentsOptions] instance.
  HybridStripePaymentsOptions({
    required this.publishableKey,
    required this.merchantName,
    required this.primaryButtonColor,
    required this.allowsDelayedPaymentMethods,
  });

  /// Converts this instance to a [Map] suitable for the method channel.
  Map<String, dynamic> toMap() {
    return {
      'publishableKey': publishableKey,
      'merchantName': merchantName,
      'primaryButtonColor': primaryButtonColor.toARGB32(),
      'allowsDelayedPaymentMethods': allowsDelayedPaymentMethods,
    };
  }
}
