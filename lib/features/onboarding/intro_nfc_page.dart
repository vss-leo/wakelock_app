import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/settings_provider.dart';
import '../../core/nfc/nfc_service.dart';

/// First intro screen asking the user to scan their NFC tag.
class IntroNfcPage extends ConsumerStatefulWidget {
  const IntroNfcPage({super.key});

  @override
  ConsumerState<IntroNfcPage> createState() => _IntroNfcPageState();
}

class _IntroNfcPageState extends ConsumerState<IntroNfcPage>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    // Delay to allow the slide-in animation.
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  Future<void> _scan() async {
    setState(() => _processing = true);
    final uid = await NfcService().readUid();
    if (uid != null) {
      ref.read(settingsProvider.notifier).updateNfcUid(uid);
    }
    if (!mounted) return;
    setState(() => _visible = false);
    await Future.delayed(const Duration(milliseconds: 250));
    if (mounted) context.go('/intro-name');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Willkommen bei WakeLock',
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text('Scanne deinen NFC-Tag, um zu starten.',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 48),
              AnimatedSlide(
                offset: _visible ? Offset.zero : const Offset(0, 0.2),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: _visible ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _processing ? null : _scan,
                      child: const Text('Tag scannen'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}