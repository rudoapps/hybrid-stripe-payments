import 'package:flutter/material.dart';
import 'package:hybrid_stripe_payments/hybrid_stripe_payments.dart';

/// Replace with your Stripe publishable key.
const _kPublishableKey =
    'pk_test_51QOymG2KORZXb9YC3JGObRdgfxk7Sk6tuRRwQE7AlLNwLZgaZJG1QA3lcyv1N8YlrNoKIGKne55r4LMJm7P4p5Mn00grpGD1oJ';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hybrid Stripe Payments Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PaymentScreen(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _stripePayments = const HybridStripePaymentsImpl();

  bool _initialized = false;
  bool _loading = false;
  String _status = 'Not initialized';

  // ---------------------------------------------------------------------------
  // 1. Initialize the plugin once at startup.
  // ---------------------------------------------------------------------------

  Future<void> _initialize() async {
    setState(() => _loading = true);
    try {
      await _stripePayments.initialize(
        HybridStripePaymentsOptions(
          publishableKey: _kPublishableKey,
          merchantName: 'Gula',
          primaryButtonColor: Colors.indigo,
          allowsDelayedPaymentMethods: true,
        ),
      );
      setState(() {
        _initialized = true;
        _status = 'Initialized successfully';
      });
    } catch (e) {
      setState(() => _status = 'Init error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // 2. Present the Stripe PaymentSheet (PaymentIntent flow).
  //    In a real app you would fetch these keys from your backend.
  // ---------------------------------------------------------------------------

  Future<void> _showPaymentSheet() async {
    setState(() => _loading = true);
    try {
      final result = await _stripePayments.showPaymentSheet(
        keys: HybridStripePaymentsKeys(
          customerId: 'cus_U3XLgfo7V44mGV',
          ephemeralKey:
              'ek_test_YWNjdF8xUU95bUcyS09SWlhiOVlDLG9Gak9hMnhEMTA5a0lBNmVoSGxLb25RdlNFOXdxMlk_00ifIkIBnj',
          type: HybridStripePaymentsKeyType.payment,
          intentId: 'pi_3T5QGi2KORZXb9YC14o1kzIf',
          clientSecret:
              'pi_3T5QGi2KORZXb9YC14o1kzIf_secret_AgRWBrzfqUCxaVmDWHL5a3S2o',
        ),
        buttonLabel: 'Pay \$9.99',
      );

      setState(() {
        _status = switch (result) {
          HybridStripePaymentsResult.completed => 'Payment completed!',
          HybridStripePaymentsResult.canceled => 'Payment canceled.',
        };
      });
    } catch (e) {
      setState(() => _status = 'Payment error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // 3. Present the Stripe SetupSheet (SetupIntent flow).
  //    Saves a payment method without charging the customer.
  // ---------------------------------------------------------------------------

  Future<void> _showSetupSheet() async {
    setState(() => _loading = true);
    try {
      final result = await _stripePayments.setupStripeSheet(
        keys: HybridStripePaymentsKeys(
          customerId: 'cus_example',
          ephemeralKey: 'ek_test_example',
          type: HybridStripePaymentsKeyType.setup,
          intentId: 'seti_example',
          clientSecret: 'seti_example_secret',
        ),
        buttonLabel: 'Save card',
      );

      setState(() {
        _status = switch (result) {
          HybridStripePaymentsResult.completed => 'Card saved!',
          HybridStripePaymentsResult.canceled => 'Setup canceled.',
        };
      });
    } catch (e) {
      setState(() => _status = 'Setup error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Payments Example')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Status: $_status'),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _initialize,
              child: const Text('Initialize Stripe'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading || !_initialized ? null : _showPaymentSheet,
              child: const Text('Show Payment Sheet'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading || !_initialized ? null : _showSetupSheet,
              child: const Text('Show Setup Sheet'),
            ),
            if (_loading) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }
}
