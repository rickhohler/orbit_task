import 'package:flutter/material.dart';

/// Provides interactive buttons to schedule and cancel tasks.
///
/// Buttons are disabled if [isInitialized] is false.
class ControlPanel extends StatelessWidget {
  final bool isInitialized;
  final VoidCallback? onScheduleSimple;
  final VoidCallback? onScheduleComplex;
  final VoidCallback? onScheduleRecurring;
  final VoidCallback? onCancelLast;
  final VoidCallback? onCancelAll;
  final VoidCallback? onClearLogs;

  const ControlPanel({
    super.key,
    required this.isInitialized,
    required this.onScheduleSimple,
    required this.onScheduleComplex,
    required this.onScheduleRecurring,
    required this.onCancelLast,
    required this.onCancelAll,
    required this.onClearLogs,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
               Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.schedule),
                    label: const Text('One-Time\n(Simple)'),
                    onPressed: isInitialized ? onScheduleSimple : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.battery_charging_full),
                    label: const Text('One-Time\n(Conn+Chrg)'),
                    onPressed: isInitialized ? onScheduleComplex : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.update),
                label: const Text('Schedule Recurring (Every 15s/15m)'),
                onPressed: isInitialized ? onScheduleRecurring : null,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancel Last'),
                    onPressed: isInitialized ? onCancelLast : null,
                    style: TextButton.styleFrom(foregroundColor: Colors.orange),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Cancel ALL'),
                    onPressed: isInitialized ? onCancelAll : null,
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear Log List'),
                onPressed: onClearLogs,
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
