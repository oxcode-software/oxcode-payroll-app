import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/subscription_provider.dart';

class LockedFeatureWidget extends StatelessWidget {
  final Widget child;
  final String featureKey;
  final String? message;

  const LockedFeatureWidget({
    super.key,
    required this.child,
    required this.featureKey,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        final isEnabled = provider.isFeatureEnabled(featureKey);

        if (isEnabled) {
          return child;
        }

        return Stack(
          children: [
            Opacity(opacity: 0.3, child: AbsorbPointer(child: child)),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock, color: Colors.amber, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        message ?? 'Premium Feature',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
