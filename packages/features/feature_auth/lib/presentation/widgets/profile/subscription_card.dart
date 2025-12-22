import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionCard extends StatelessWidget {
  final dynamic status;

  const SubscriptionCard({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status == null || status.subscription == null) {
      return _buildFreeCard(context);
    }
    return _buildActiveCard(context);
  }

  Widget _buildFreeCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Free Plan', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Upgrade to unlock premium features.'),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveCard(BuildContext context) {
    final sub = status.subscription!;
    final date = sub.endDate;
    final dateStr = DateFormat.yMMMd().format(date);

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Active Subscription',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            Text(sub.plan.displayName,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text('Renews on $dateStr'),
          ],
        ),
      ),
    );
  }
}

class SubscriptionCardError extends StatelessWidget {
  final String message;
  const SubscriptionCardError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Error: $message'),
      ),
    );
  }
}

class SubscriptionCardLoading extends StatelessWidget {
  const SubscriptionCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
