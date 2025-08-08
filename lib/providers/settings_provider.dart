import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/settings.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateNfcUid(String uid) {
    state = state.copyWith(nfcUid: uid);
  }

  void updateRampSeconds(int seconds) {
    state = state.copyWith(globalRampSeconds: seconds);
  }

  void updatePin(String? pin) {
    state = state.copyWith(pin: pin);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier();
});