import 'package:flutter/material.dart';

/// Displays the initialization status of the OrbitTask plugin.
class StatusPanel extends StatelessWidget {
  /// Whether the plugin has been successfully initialized.
  final bool isInitialized;

  const StatusPanel({super.key, required this.isInitialized});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      // Visual feedback: Green for ready, Red for uninitialized.
      // Using withValues(alpha: 0.1) as replacement for deprecated withOpacity.
      color: isInitialized 
          ? Colors.green.withValues(alpha: 0.1) 
          : Colors.red.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            isInitialized ? Icons.check_circle : Icons.error_outline,
            color: isInitialized ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isInitialized ? 'System Initialized' : 'System Not Initialized',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'Ready to schedule tasks',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
