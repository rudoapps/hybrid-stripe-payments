import 'package:hybrid_stripe_payments/src/domain/exceptions/hybrid_stripe_payments_parse_exception.dart';
import 'package:hybrid_stripe_payments/src/domain/entity/keys/hybrid_stripe_payments_key_type.dart';

/// Ephemeral credentials and intent details required by the Stripe SDK
/// to present a payment or setup sheet.
class HybridStripePaymentsKeys {
  /// The Stripe Customer ID (e.g. `cus_xxx`).
  final String customerId;

  /// The ephemeral key secret used to authenticate the customer session.
  final String ephemeralKey;

  /// The type of Stripe intent ([HybridStripePaymentsKeyType.payment] or
  /// [HybridStripePaymentsKeyType.setup]).
  final HybridStripePaymentsKeyType type;

  /// The Stripe Intent ID (PaymentIntent or SetupIntent).
  final String intentId;

  /// The client secret of the Stripe Intent.
  final String clientSecret;

  /// Creates a new [HybridStripePaymentsKeys] instance.
  HybridStripePaymentsKeys({
    required this.customerId,
    required this.ephemeralKey,
    required this.type,
    required this.intentId,
    required this.clientSecret,
  });

  /// Returns a copy of this instance with the given fields replaced.
  HybridStripePaymentsKeys copyWith({
    String? customerId,
    String? ephemeralKey,
    HybridStripePaymentsKeyType? type,
    String? intentId,
    String? clientSecret,
  }) {
    return HybridStripePaymentsKeys(
      customerId: customerId ?? this.customerId,
      ephemeralKey: ephemeralKey ?? this.ephemeralKey,
      type: type ?? this.type,
      intentId: intentId ?? this.intentId,
      clientSecret: clientSecret ?? this.clientSecret,
    );
  }

  /// Creates a [HybridStripePaymentsKeys] from a [Map].
  ///
  /// Throws a [HybridStripePaymentsParseException] if the map cannot be parsed.
  factory HybridStripePaymentsKeys.fromMap(Map<String, dynamic> map) {
    try {
      return HybridStripePaymentsKeys(
        customerId: map['customerId'],
        ephemeralKey: map['ephemeralKey'],
        type: HybridStripePaymentsKeyType.fromString(map['type']),
        intentId: map['intentId'],
        clientSecret: map['clientSecret'],
      );
    } catch (e) {
      throw HybridStripePaymentsParseException(
        'Failed to parse StripeKeys: $e',
      );
    }
  }

  /// Converts this instance to a [Map] suitable for the method channel.
  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'ephemeralKey': ephemeralKey,
      'type': type.value,
      'intentId': intentId,
      'clientSecret': clientSecret,
    };
  }
}
