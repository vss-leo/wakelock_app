import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ringing_provider.dart';
import '../../providers/alarms_provider.dart';
import '../../providers/settings_provider.dart';
import '../../core/nfc/nfc_service.dart';
import '../../core/audio/audio_player_service.dart';
import '../alarms/alarms_page.dart';

/// Screen shown when an alarm is ringing. Allows one snooze and NFC stop.
class RingingPage extends ConsumerStatefulWidget {
  const RingingPage({super.key});

  @override
  ConsumerState<RingingPage> createState() => _RingingPageState();
}

class _RingingPageState extends ConsumerState<RingingPage> {
  final _audio = AudioPlayerService();
  bool scanning = false;

  @override
  void initState() {
    super.initState();
    final rampSeconds = ref.read(settingsProvider).globalRampSeconds;
    _audio.play(assetPath: 'assets/sounds/alarm.mp3', rampSeconds: rampSeconds);
  }

  @override
  void dispose() {
    _audio.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ringing = ref.watch(ringingProvider);
    final snoozed = ringing.snoozeUsed;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Alarm', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            if (!scanning) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: snoozed
                        ? null
                        : () {
                            ref.read(ringingProvider.notifier).useSnooze();
                            _audio.stop();
                            Navigator.of(context).pop();
                            // In actual implementation: schedule next ring in 5 minutes.
                          },
                    child: Text(snoozed ? 'Snoozed' : 'Snooze'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => scanning = true);
                      final uid = await NfcService().readUid();
                      setState(() => scanning = false);
                      final regUid = ref.read(settingsProvider).nfcUid;
                      if (uid != null && regUid != null && uid == regUid) {
                        ref.read(ringingProvider.notifier).stopRinging();
                        _audio.stop();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const AlarmsPage()),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Wrong tag. Try again')));
                      }
                    },
                    child: const Text('Stop'),
                  ),
                ],
              ),
            ] else
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}