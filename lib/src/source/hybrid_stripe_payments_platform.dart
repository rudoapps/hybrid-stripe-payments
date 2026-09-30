import 'package:hybrid_stripe_payments/src/domain/entity/keys/hybrid_stripe_payments_keys.dart';
import 'package:hybrid_stripe_payments/src/domain/entity/options/hybrid_stripe_payments_options.dart';
import 'package:hybrid_stripe_payments/src/domain/entity/result/hybrid_stripe_payments_result.dart';
import 'package:hybrid_stripe_payments/src/hybrid_stripe_payments_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Platform interface for the Hybrid Stripe Payments plugin.
///
/// Platform-specific implementations should extend this class and override
/// its methods to provide native Stripe SDK functionality.
abstract class HybridStripePaymentsPlatform extends PlatformInterface {
  /// Constructs a HybridStripePaymentsPlatform.
  HybridStripePaymentsPlatform() : super(token: _token);

  static final Object _token = Object();

  static HybridStripePaymentsPlatform _instance =
      HybridStripePaymentsMethodChannel();

  /// The default instance of [HybridStripePaymentsPlatform] to use.
  ///
  /// Defaults to [HybridStripePaymentsMethodChannel].
  static HybridStripePaymentsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridStripePaymentsPlatform] when
  /// they register themselves.
  static set instance(HybridStripePaymentsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the native Stripe SDK with the given [options].
  Future<void> initialize(HybridStripePaymentsOptions options) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  /// Presents the Stripe payment sheet using the provided [keys].
  Future<HybridStripePaymentsResult> showPaymentSheet({
    required HybridStripePaymentsKeys keys,
    String? buttonLabel,
  }) {
    throw UnimplementedError('showPaymentSheet() has not been implemented.');
  }

  /// Presents the Stripe setup sheet using the provided [keys].
  Future<HybridStripePaymentsResult> setupStripeSheet({
    required HybridStripePaymentsKeys keys,
    String? buttonLabel,
  }) {
    throw UnimplementedError('setupStripeSheet() has not been implemented.');
  }
}
