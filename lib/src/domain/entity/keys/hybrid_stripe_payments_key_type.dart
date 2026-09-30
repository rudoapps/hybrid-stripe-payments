/// The type of Stripe intent associated with a set of keys.
enum HybridStripePaymentsKeyType {
  /// A PaymentIntent-based flow, used to collect a payment.
  payment('PAYMENT'),

  /// A SetupIntent-based flow, used to save a payment method without charging.
  setup('SETUP'),

  /// No intent type specified.
  none('NONE');

  /// The raw string value sent to the native platform.
  final String value;

  const HybridStripePaymentsKeyType(this.value);

  /// Returns the [HybridStripePaymentsKeyType] matching the given [value],
  /// or [none] if no match is found.
  static HybridStripePaymentsKeyType fromString(String value) {
    return HybridStripePaymentsKeyType.values.firstWhere(
      (element) => element.value == value,
      orElse: () => HybridStripePaymentsKeyType.none,
    );
  }
}
