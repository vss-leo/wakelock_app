import 'package:hive/hive.dart';

part 'alarm.g.dart';

@HiveType(typeId: 0)
class Alarm {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int hour;
  @HiveField(2)
  final int minute;
  @HiveField(3)
  final bool enabled;
  @HiveField(4)
  final int rampSeconds;

  Alarm({required this.id, required this.hour, required this.minute, this.enabled = true, this.rampSeconds = 0});

  Alarm copyWith({String? id, int? hour, int? minute, bool? enabled, int? rampSeconds}) {
    return Alarm(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      enabled: enabled ?? this.enabled,
      rampSeconds: rampSeconds ?? this.rampSeconds,
    );
  }
}