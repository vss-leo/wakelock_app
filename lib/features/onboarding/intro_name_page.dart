import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/settings_provider.dart';

/// Page for entering user's name and optional PIN.
class IntroNamePage extends ConsumerStatefulWidget {
  const IntroNamePage({super.key});

  @override
  ConsumerState<IntroNamePage> createState() => _IntroNamePageState();
}

class _IntroNamePageState extends ConsumerState<IntroNamePage> {
  final _nameController = TextEditingController();
  final _pinController = TextEditingController();

  bool _nameVisible = false;
  bool _pinVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _nameVisible = true);
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _pinVisible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameFilled = _nameController.text.trim().isNotEmpty;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSlide(
                offset: _nameVisible ? Offset.zero : const Offset(0, 0.2),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                child: AnimatedOpacity(
                  opacity: _nameVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                    decoration: const InputDecoration(
                      hintText: 'Dein Name',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedSlide(
                offset: _pinVisible ? Offset.zero : const Offset(0, 0.2),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                child: AnimatedOpacity(
                  opacity: _pinVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: TextField(
                    controller: _pinController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Fallback PIN (optional)',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: nameFilled
                      ? () {
                          final name = _nameController.text.trim();
                          final pin = _pinController.text.trim();
                          ref.read(settingsProvider.notifier).updateName(name);
                          if (pin.isNotEmpty) {
                            ref.read(settingsProvider.notifier).updatePin(pin);
                          }
                          context.go('/alarms');
                        }
                      : null,
                  child: const Text('Weiter'),
                ),
              ),
            ],
          ),
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