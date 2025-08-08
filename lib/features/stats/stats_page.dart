import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/stats_provider.dart';

/// Page showing simple statistics about user's wake history.
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Punctuality Score: ${stats.punctualityScore}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Consistency (SD): ${stats.consistencyMin.toStringAsFixed(1)} min'),
            const SizedBox(height: 16),
            const Text('History:'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: stats.history.length,
                itemBuilder: (context, index) {
                  final e = stats.history[index];
                  return ListTile(
                    title: Text(
                        'Stop: ${e.stopTime.hour.toString().padLeft(2, '0')}:${e.stopTime.minute.toString().padLeft(2, '0')}'),
                    subtitle: Text(
                        'Ring: ${e.ringTime.hour.toString().padLeft(2, '0')}:${e.ringTime.minute.toString().padLeft(2, '0')} | Snoozed: ${e.snoozed}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}