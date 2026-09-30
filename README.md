![Banner](https://raw.githubusercontent.com/rudoapps/hybrid-hub-vault/main/flutter/images/hybrid-stripe-payments/banner.png)

# Hybrid Stripe Payments

A Flutter plugin that provides a unified Dart API to present native Stripe **PaymentSheet** and **SetupSheet** on Android and iOS. It wraps the official Stripe SDKs so you can collect payments or save payment methods with minimal setup.

| Platform | Min version | Stripe SDK |
|----------|-------------|------------|
| Android  | API 24      | `com.stripe:stripe-android:21.20.2` |
| iOS      | 13.0        | `StripePaymentSheet` (CocoaPods) |

## Features

- **Collect payments** — present the Stripe PaymentSheet backed by a `PaymentIntent`.
- **Save payment methods** — present a setup sheet backed by a `SetupIntent` to attach a card without charging.
- **Customizable UI** — set the merchant name, primary button color, and button label.
- **Delayed payment methods** — optionally allow methods like SEPA Debit or Sofort that confirm asynchronously.

## Installation

Add this package to your pubspec.yaml:

```yaml
dependencies:
  hybrid_stripe_payments: ^1.0.0
```


## Quick start

### 1. Initialize the plugin

Call `initialize` once at app startup (e.g. in `main()` or a splash screen):

```dart
import 'package:hybrid_stripe_payments/hybrid_stripe_payments.dart';

final stripePayments = HybridStripePaymentsImpl();

await stripePayments.initialize(
  HybridStripePaymentsOptions(
    publishableKey: 'pk_test_xxx',
    merchantName: 'My Store',
    primaryButtonColor: Colors.blue,
    allowsDelayedPaymentMethods: true,
  ),
);
```

### 2. Collect a payment

Create a `PaymentIntent` on your backend, then pass the returned keys to `showPaymentSheet`:

```dart
final result = await stripePayments.showPaymentSheet(
  keys: HybridStripePaymentsKeys(
    customerId: 'cus_xxx',
    ephemeralKey: 'ek_test_xxx',
    type: HybridStripePaymentsKeyType.payment,
    intentId: 'pi_xxx',
    clientSecret: 'pi_xxx_secret_xxx',
  ),
  buttonLabel: 'Pay now', // optional
);

switch (result) {
  case HybridStripePaymentsResult.completed:
    // Show a confirmation screen.
    // Wait for a webhook event to fulfill the order.
    break;
  case HybridStripePaymentsResult.canceled:
    // The customer dismissed the sheet.
    break;
}
```

### 3. Save a payment method (no charge)

Create a `SetupIntent` on your backend, then call `setupStripeSheet`:

```dart
final result = await stripePayments.setupStripeSheet(
  keys: HybridStripePaymentsKeys(
    customerId: 'cus_xxx',
    ephemeralKey: 'ek_test_xxx',
    type: HybridStripePaymentsKeyType.setup,
    intentId: 'seti_xxx',
    clientSecret: 'seti_xxx_secret_xxx',
  ),
  buttonLabel: 'Save card', // optional
);
```

## API reference

### `HybridStripePaymentsImpl`

| Method | Description |
|--------|-------------|
| `Future<void> initialize(HybridStripePaymentsOptions options)` | Initialize the Stripe SDK. Call once before any sheet. |
| `Future<HybridStripePaymentsResult> showPaymentSheet({required HybridStripePaymentsKeys keys, String? buttonLabel})` | Present the PaymentSheet to collect a payment. |
| `Future<HybridStripePaymentsResult> setupStripeSheet({required HybridStripePaymentsKeys keys, String? buttonLabel})` | Present the setup sheet to save a payment method. |

### `HybridStripePaymentsOptions`

| Parameter | Type | Description |
|-----------|------|-------------|
| `publishableKey` | `String` | Stripe publishable key (`pk_live_xxx` or `pk_test_xxx`). |
| `merchantName` | `String` | Display name shown in the payment sheet. |
| `primaryButtonColor` | `Color` | Color of the confirmation button. |
| `allowsDelayedPaymentMethods` | `bool` | Allow methods that confirm asynchronously (SEPA, Sofort, etc.). |

### `HybridStripePaymentsKeys`

| Parameter | Type | Description |
|-----------|------|-------------|
| `customerId` | `String` | Stripe Customer ID (`cus_xxx`). |
| `ephemeralKey` | `String` | Ephemeral key secret for the customer session. |
| `type` | `HybridStripePaymentsKeyType` | `payment` or `setup`. |
| `intentId` | `String` | The PaymentIntent or SetupIntent ID. |
| `clientSecret` | `String` | Client secret of the intent. |

### `HybridStripePaymentsKeyType`

| Value | Description |
|-------|-------------|
| `payment` | PaymentIntent-based flow. |
| `setup` | SetupIntent-based flow. |
| `none` | No intent type specified. |

### `HybridStripePaymentsResult`

| Value | Description |
|-------|-------------|
| `completed` | The customer completed the flow. The payment may still be processing — listen for [Stripe webhook events](https://stripe.com/docs/payments/handling-payment-events) before fulfilling. |
| `canceled` | The customer dismissed the sheet. |

## Backend requirements

The plugin does **not** communicate with Stripe servers directly. Your backend must provide:

1. **Customer ID** — create or retrieve a Stripe Customer (`cus_xxx`).
2. **Ephemeral Key** — call `POST /v1/ephemeral_keys` with the customer ID.
3. **PaymentIntent** (for payments) — call `POST /v1/payment_intents` and return the `id` and `client_secret`.
4. **SetupIntent** (for saving cards) — call `POST /v1/setup_intents` and return the `id` and `client_secret`.

See the [Stripe PaymentSheet guide](https://docs.stripe.com/payments/accept-a-payment?platform=flutter&ui=payment-sheet) for a full backend walkthrough.

## Author
Miguel Ángel Soto Gonzalez - msoto@laberit.com

## License

MIT — see [LICENSE](LICENSE) for details.
