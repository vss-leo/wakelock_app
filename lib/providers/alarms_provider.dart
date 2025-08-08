import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/alarm.dart';

final _uuid = Uuid();

class AlarmsNotifier extends StateNotifier<List<Alarm>> {
  AlarmsNotifier() : super([]);

  void addAlarm(int hour, int minute, int rampSeconds) {
    final alarm = Alarm(id: _uuid.v4(), hour: hour, minute: minute, rampSeconds: rampSeconds);
    state = [...state, alarm]..sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
  }

  void updateAlarm(Alarm updated) {
    state = state.map((a) => a.id == updated.id ? updated : a).toList();
  }

  void removeAlarm(String id) {
    state = state.where((a) => a.id != id).toList();
  }

  void toggleAlarm(String id, bool enabled) {
    state = state
        .map(
          (a) => a.id == id ? a.copyWith(enabled: enabled) : a,
        )
        .toList();
  }
}

final alarmsProvider = StateNotifierProvider<AlarmsNotifier, List<Alarm>>((ref) {
  return AlarmsNotifier();
});