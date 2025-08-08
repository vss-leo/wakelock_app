import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/alarms_provider.dart';
import '../../data/models/alarm.dart';

/// Bottom sheet for creating or editing an alarm.
class EditAlarmSheet extends ConsumerStatefulWidget {
  final Alarm? alarm;
  const EditAlarmSheet({super.key, this.alarm});

  @override
  ConsumerState<EditAlarmSheet> createState() => _EditAlarmSheetState();
}

class _EditAlarmSheetState extends ConsumerState<EditAlarmSheet> {
  late int hour;
  late int minute;
  late int ramp;

  @override
  void initState() {
    super.initState();
    final a = widget.alarm;
    hour = a?.hour ?? TimeOfDay.now().hour;
    minute = a?.minute ?? TimeOfDay.now().minute;
    ramp = a?.rampSeconds ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final hours = List.generate(24, (i) => i);
    final minutes = List.generate(60, (i) => i);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.alarm == null ? 'New Alarm' : 'Edit Alarm',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPicker(
                context,
                label: 'Hour',
                values: hours,
                selected: hour,
                onSelected: (v) => setState(() => hour = v),
              ),
              _buildPicker(
                context,
                label: 'Minute',
                values: minutes,
                selected: minute,
                onSelected: (v) => setState(() => minute = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Ramp-up'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: ramp,
                items: const [0, 10, 20, 30, 40, 50, 60]
                    .map((s) => DropdownMenuItem(value: s, child: Text('$s s')))
                    .toList(),
                onChanged: (v) => setState(() => ramp = v ?? 0),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.alarm == null) {
                      ref.read(alarmsProvider.notifier).addAlarm(hour, minute, ramp);
                    } else {
                      final updated = widget.alarm!.copyWith(
                          hour: hour, minute: minute, rampSeconds: ramp);
                      ref.read(alarmsProvider.notifier).updateAlarm(updated);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPicker(BuildContext context,
      {required String label,
      required List<int> values,
      required int selected,
      required ValueChanged<int> onSelected}) {
    return Column(
      children: [
        Text(label),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          width: 60,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) => onSelected(values[i]),
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final val = values[index];
                return Center(
                  child: Text(val.toString().padLeft(2, '0'),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: val == selected ? FontWeight.bold : null)),
                );
              },
              childCount: values.length,
            ),
          ),
        ),
      ],
    );
  }
}