import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/alarms_provider.dart';
import 'edit_alarm_sheet.dart';
import '../settings/gentle_wake_page.dart';

import '../../data/models/alarm.dart';

/// Page showing all alarms and allowing creating/editing.
class AlarmsPage extends ConsumerWidget {
  const AlarmsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmsProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          final a = alarms[index];
          final time = '${a.hour.toString().padLeft(2, '0')}:${a.minute.toString().padLeft(2, '0')}';
          final tile = ListTile(
            title: Text(
              time,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Repeats Weekdays',
              style: TextStyle(color: Color(0xFF9E9E9E)),
            ),
            trailing: Switch(
              value: a.enabled,
              onChanged: (v) =>
                  ref.read(alarmsProvider.notifier).toggleAlarm(a.id, v),
            ),
            onTap: () => _openEdit(context, a),
          );
          return a.enabled ? tile : Opacity(opacity: 0.5, child: tile);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.alarm),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _openEdit(context, null),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const GentleWakePage()),
                  );
                },
              ),
            ],
          ),
        ),
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