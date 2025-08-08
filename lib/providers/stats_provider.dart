import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/history_entry.dart';

class StatsState {
  final List<HistoryEntry> history;
  final int punctualityScore;
  final double consistencyMin;

  StatsState({required this.history, this.punctualityScore = 0, this.consistencyMin = 0});
}

class StatsNotifier extends StateNotifier<StatsState> {
  StatsNotifier() : super(StatsState(history: []));

  void addEntry(HistoryEntry entry) {
    final updatedHistory = [...state.history, entry];
    final stats = _computeStats(updatedHistory);
    state = StatsState(
      history: updatedHistory,
      punctualityScore: stats['score'] as int,
      consistencyMin: stats['variance'] as double,
    );
  }

  Map<String, dynamic> _computeStats(List<HistoryEntry> entries) {
    if (entries.isEmpty) return {'score': 0, 'variance': 0.0};
    final diffs = <int>[];
    final times = <int>[];
    for (final e in entries) {
      final diff = e.stopTime.difference(e.ringTime).inMinutes;
      diffs.add(diff);
      times.add(e.stopTime.hour * 60 + e.stopTime.minute);
    }
    final meanDiff = diffs.reduce((a, b) => a + b) / diffs.length;
    final meanTime = times.reduce((a, b) => a + b) / times.length;
    final varTime = times.map((t) => pow(t - meanTime, 2)).reduce((a, b) => a + b) / times.length;
    final consistencyMin = sqrt(varTime).toDouble();
    var score = max(0, 100 - meanDiff.abs() * 4 - (entries.where((e) => e.snoozed).length * 10));
    return {'score': score, 'variance': consistencyMin};
  }
}

final statsProvider = StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  return StatsNotifier();
});