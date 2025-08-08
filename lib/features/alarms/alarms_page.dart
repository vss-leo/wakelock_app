import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/alarms_provider.dart';
import '../../providers/settings_provider.dart';
import 'edit_alarm_sheet.dart';
import '../stats/stats_page.dart';

import '../../data/models/alarm.dart';

/// Page showing all alarms and allowing creating/editing.
class AlarmsPage extends ConsumerWidget {
  const AlarmsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmsProvider);
    final name = ref.watch(settingsProvider).name;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello${name != null && name.isNotEmpty ? ', $name' : ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StatsPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          final a = alarms[index];
          return ListTile(
            title: Text(
              '${a.hour.toString().padLeft(2, '0')}:${a.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 24),
            ),
            subtitle:
                Text('Ramp-up: ${a.rampSeconds}s', style: const TextStyle(fontSize: 12)),
            trailing: Switch(
              value: a.enabled,
              onChanged: (v) => ref.read(alarmsProvider.notifier).toggleAlarm(a.id, v),
            ),
            onTap: () => _openEdit(context, a),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEdit(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openEdit(BuildContext context, Alarm? alarm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: EditAlarmSheet(alarm: alarm),
      ),
    );
  }
}