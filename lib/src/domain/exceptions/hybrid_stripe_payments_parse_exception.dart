/// Exception thrown when a value cannot be parsed into the expected type.
class HybridStripePaymentsParseException implements Exception {
  /// A readable description of the parsing error.
  final String message;

  /// Creates a [HybridStripePaymentsParseException] with the given [message].
  HybridStripePaymentsParseException(this.message);

  @override
  String toString() => 'HybridStripePaymentsParseException: $message';
}
