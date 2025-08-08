import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../core/nfc/nfc_service.dart';
import 'intro_name_page.dart';

/// Page prompting the user to register an NFC tag. They can also skip.
class IntroNfcPage extends ConsumerWidget {
  const IntroNfcPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Scan your NFC tag to register it. You can skip for now.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final uid = await NfcService().readUid();
                if (uid != null) {
                  ref.read(settingsProvider.notifier).updateNfcUid(uid);
                }
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const IntroNamePage()),
                  );
                }
              },
              child: const Text('Scan NFC Tag'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const IntroNamePage()),
                );
              },
              child: const Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}