import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 2)
class Settings {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final String? nfcUid;
  @HiveField(2)
  final int globalRampSeconds;
  @HiveField(3)
  final String? pin;

  /// Creates a new [Settings] instance.
  ///
  /// The default for [globalRampSeconds] is 30 which matches the
  /// "Gentle Wake" default from the design specifications.
  Settings({this.name, this.nfcUid, this.globalRampSeconds = 30, this.pin});

  Settings copyWith({String? name, String? nfcUid, int? globalRampSeconds, String? pin}) {
    return Settings(
      name: name ?? this.name,
      nfcUid: nfcUid ?? this.nfcUid,
      globalRampSeconds: globalRampSeconds ?? this.globalRampSeconds,
      pin: pin ?? this.pin,
    );
  }
}