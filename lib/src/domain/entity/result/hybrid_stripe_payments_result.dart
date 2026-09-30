import 'package:hybrid_stripe_payments/src/domain/exceptions/hybrid_stripe_payments_parse_exception.dart';

/// The result of a Stripe sheet presentation.
///
/// This enum is used to indicate the result of a Stripe sheet presentation.
///
/// - [completed]: The customer completed the payment or setup.
/// - [canceled]: The customer canceled the payment or setup attempt.
/// - When a payment or setup fails, the error is shown directly to the user in the sheet (e.g. if payment failed).
enum HybridStripePaymentsResult {
  /// The customer completed the payment or setup
  /// - Note: The payment may still be processing at this point; don't assume money has successfully moved.
  ///
  /// Your app should transition to a generic receipt view (e.g. a screen that displays "Your order is confirmed!"), and
  /// fulfill the order (e.g. ship the product to the customer) after receiving a successful payment event from Stripe -
  /// see https://stripe.com/docs/payments/handling-payment-events
  completed('completed'),

  /// The customer canceled the payment or setup attempt
  canceled('canceled');

  /// The raw string value received from the native platform.
  final String value;

  const HybridStripePaymentsResult(this.value);

  /// Returns the [HybridStripePaymentsResult] matching the given [value].
  ///
  /// Throws a [HybridStripePaymentsParseException] if the value is not recognized.
  static HybridStripePaymentsResult fromString(String value) {
    return switch (value) {
      'completed' => HybridStripePaymentsResult.completed,
      'canceled' => HybridStripePaymentsResult.canceled,
      _ => throw HybridStripePaymentsParseException('Invalid value: $value'),
    };
  }
}
