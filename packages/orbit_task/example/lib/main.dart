import 'package:flutter/material.dart';
import 'package:orbit_task/orbit_task.dart';

// Top-level function for background task execution
@pragma('vm:entry-point')
void backgroundDispatcher() {
  OrbitTask.instance.registerHandler('simpleTask', (inputData) async {
    print("Background Task Executed: $inputData");
    return TaskResult.success();
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Idle';

  @override
  void initState() {
    super.initState();
    _initOrbitTask();
  }

  Future<void> _initOrbitTask() async {
    await OrbitTask.instance.initialize(dispatcher: backgroundDispatcher);
    setState(() {
      _status = 'Initialized';
    });
  }

  Future<void> _scheduleTask() async {
    try {
      await OrbitTask.instance.scheduleOneTime(
        taskName: 'simpleTask',
        inputData: {'timestamp': DateTime.now().toIso8601String()},
      );
      setState(() {
        _status = 'Task Scheduled';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('OrbitTask Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Status: $_status'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _scheduleTask,
                child: const Text('Schedule One-Time Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
