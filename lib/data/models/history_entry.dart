import 'package:hive/hive.dart';

part 'history_entry.g.dart';

@HiveType(typeId: 1)
class HistoryEntry {
  @HiveField(0)
  final DateTime ringTime;
  @HiveField(1)
  final DateTime stopTime;
  @HiveField(2)
  final bool snoozed;

  HistoryEntry({required this.ringTime, required this.stopTime, this.snoozed = false});
}