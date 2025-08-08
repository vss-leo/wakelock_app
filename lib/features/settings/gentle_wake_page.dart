import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

/// Screen allowing the user to configure the global "Gentle Wake" ramp up
/// duration. The chosen value is stored in [Settings] via [settingsProvider].
class GentleWakePage extends ConsumerWidget {
  const GentleWakePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(settingsProvider).globalRampSeconds;
    void update(int? v) {
      if (v != null) {
        ref.read(settingsProvider.notifier).updateRampSeconds(v);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Gentle Wake'),
      ),
      body: ListView(
        children: [
          RadioListTile<int>(
            title: const Text('None'),
            value: 0,
            groupValue: selected,
            onChanged: update,
          ),
          RadioListTile<int>(
            title: const Text('30 Seconds'),
            value: 30,
            groupValue: selected,
            onChanged: update,
          ),
          RadioListTile<int>(
            title: const Text('60 Seconds'),
            value: 60,
            groupValue: selected,
            onChanged: update,
          ),
          RadioListTile<int>(
            title: const Text('90 Seconds'),
            value: 90,
            groupValue: selected,
            onChanged: update,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Gentle Wake is the length of time it takes for the alarm to reach maximum volume.',
              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
