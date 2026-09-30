import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_stripe_payments/src/domain/entity/keys/hybrid_stripe_payments_keys.dart';
import 'package:hybrid_stripe_payments/src/domain/entity/options/hybrid_stripe_payments_options.dart';
import 'package:hybrid_stripe_payments/src/domain/entity/result/hybrid_stripe_payments_result.dart';
import 'package:hybrid_stripe_payments/src/source/hybrid_stripe_payments_platform.dart';

/// An implementation of [HybridStripePaymentsPlatform] that uses method channels.
class HybridStripePaymentsMethodChannel extends HybridStripePaymentsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.rudo/hybrid_stripe_payments');

  @override
  Future<void> initialize(HybridStripePaymentsOptions options) async {
    await methodChannel.invokeMethod<void>('initialize', {
      'options': options.toMap(),
    });
  }

  @override
  Future<HybridStripePaymentsResult> showPaymentSheet({
    required HybridStripePaymentsKeys keys,
    String? buttonLabel,
  }) async {
    final arguments = <String, dynamic>{
      'keys': keys.toMap(),
      if (buttonLabel != null) 'buttonLabel': buttonLabel,
    };
    final String? result = await methodChannel.invokeMethod<String>(
      'showPaymentSheet',
      arguments,
    );

    return HybridStripePaymentsResult.fromString(
      result ?? HybridStripePaymentsResult.canceled.value,
    );
  }

  @override
  Future<HybridStripePaymentsResult> setupStripeSheet({
    required HybridStripePaymentsKeys keys,
    String? buttonLabel,
  }) async {
    final arguments = <String, dynamic>{
      'keys': keys.toMap(),
      if (buttonLabel != null) 'buttonLabel': buttonLabel,
    };
    final String? result = await methodChannel.invokeMethod<String>(
      'setupStripeSheet',
      arguments,
    );

    return HybridStripePaymentsResult.fromString(
      result ?? HybridStripePaymentsResult.canceled.value,
    );
  }
}
