import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../alarms/alarms_page.dart';

/// Page for entering user's name and optional PIN.
class IntroNamePage extends ConsumerStatefulWidget {
  const IntroNamePage({super.key});

  @override
  ConsumerState<IntroNamePage> createState() => _IntroNamePageState();
}

class _IntroNamePageState extends ConsumerState<IntroNamePage> {
  final _nameController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Almost there')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Your name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                  labelText: 'Optional PIN (4 digits)', hintText: '****'),
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final pin = _pinController.text.trim();
                ref.read(settingsProvider.notifier).updateName(name);
                if (pin.isNotEmpty) {
                  ref.read(settingsProvider.notifier).updatePin(pin);
                }
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const AlarmsPage()),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pinController.dispose();
    super.dispose();
  }
}