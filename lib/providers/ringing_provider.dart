import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds state for current ringing alarm.
class RingingState {
  final bool isRinging;
  final String? alarmId;
  final bool snoozeUsed;

  const RingingState({this.isRinging = false, this.alarmId, this.snoozeUsed = false});

  RingingState copyWith({bool? isRinging, String? alarmId, bool? snoozeUsed}) {
    return RingingState(
      isRinging: isRinging ?? this.isRinging,
      alarmId: alarmId ?? this.alarmId,
      snoozeUsed: snoozeUsed ?? this.snoozeUsed,
    );
  }
}

class RingingNotifier extends StateNotifier<RingingState> {
  RingingNotifier() : super(const RingingState());

  void startRinging(String alarmId) {
    state = state.copyWith(isRinging: true, alarmId: alarmId, snoozeUsed: false);
  }

  void stopRinging() {
    state = state.copyWith(isRinging: false, alarmId: null);
  }

  void useSnooze() {
    state = state.copyWith(snoozeUsed: true);
  }
}

final ringingProvider = StateNotifierProvider<RingingNotifier, RingingState>((ref) {
  return RingingNotifier();
});