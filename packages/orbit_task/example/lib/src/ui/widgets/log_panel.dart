import 'package:flutter/material.dart';

class LogPanel extends StatelessWidget {
  final List<String> logs;
  final ScrollController scrollController;

  const LogPanel({
    super.key,
    required this.logs,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Center(
        child: Text(
          'No activity logs yet. Try scheduling a task.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(
            logs[index],
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
        );
      },
    );
  }
}
