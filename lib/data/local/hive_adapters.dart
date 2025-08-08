import 'package:hive_flutter/hive_flutter.dart';
import '../models/alarm.dart';
import '../models/history_entry.dart';
import '../models/settings.dart';

/// Initializes Hive and registers all adapters.
Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmAdapter());
  Hive.registerAdapter(HistoryEntryAdapter());
  Hive.registerAdapter(SettingsAdapter());
}