import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ringing_provider.dart';
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
  int _snoozeRemaining = 0;
  Timer? _snoozeTimer;

  @override
  void initState() {
    super.initState();
    final rampSeconds = ref.read(settingsProvider).globalRampSeconds;
    _audio.play(assetPath: 'assets/sounds/alarm.mp3', rampSeconds: rampSeconds);
  }

  @override
  void dispose() {
    _snoozeTimer?.cancel();
    _audio.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ringing = ref.watch(ringingProvider);
    final snoozed = ringing.snoozeUsed;
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Alarm',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(160, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _startScan(context),
                  child: const Text('Turn Off'),
                ),
              ),
              const SizedBox(height: 12),
              if (snoozed && _snoozeRemaining > 0)
                Text(
                  '${_formatSnooze()} Snooze Remaining',
                  style: const TextStyle(color: Color(0xFF9E9E9E)),
                )
              else
                TextButton(
                  onPressed: snoozed ? null : _snooze,
                  child: const Text('Snooze'),
                ),
              const SizedBox(height: 8),
              const Text(
                'Walk to device to turn off alarm.',
                style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSnooze() {
    final m = (_snoozeRemaining ~/ 60).toString().padLeft(1, '0');
    final s = (_snoozeRemaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _snooze() {
    ref.read(ringingProvider.notifier).useSnooze();
    setState(() {
      _snoozeRemaining = 120;
    });
    _audio.stop();
    _snoozeTimer?.cancel();
    _snoozeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_snoozeRemaining <= 1) {
        timer.cancel();
        _audio.play(assetPath: 'assets/sounds/alarm.mp3', rampSeconds: ref.read(settingsProvider).globalRampSeconds);
        setState(() {
          _snoozeRemaining = 0;
        });
      } else {
        setState(() {
          _snoozeRemaining--;
        });
      }
    });
  }

  Future<void> _startScan(BuildContext context) async {
    final uid = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        NfcService().readUid().then((value) {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop(value);
          }
        });
        return AlertDialog(
          title: const Text('Ready to Scan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Hold the top of your phone near your wakelock device.'),
              SizedBox(height: 16),
              Icon(Icons.nfc, size: 48, color: Color(0xFF007AFF)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    final regUid = ref.read(settingsProvider).nfcUid;
    if (uid != null && regUid != null && uid == regUid) {
      ref.read(ringingProvider.notifier).stopRinging();
      _audio.stop();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AlarmsPage()),
          (route) => false,
        );
      }
    } else if (uid != null && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Wrong tag. Try again')));
    }
  }
}