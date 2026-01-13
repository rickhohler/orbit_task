import 'dart:ui';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:orbit_task/orbit_task.dart';
import 'package:intl/intl.dart';
import '../background/background_dispatcher.dart';
import 'widgets/status_panel.dart';
import 'widgets/log_panel.dart';
import 'widgets/control_panel.dart';

/// The main logical screen for the example app.
///
/// Orchestrates initialization, task scheduling, result logging, and UI updates.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _logs = [];
  final ScrollController _logScrollController = ScrollController();
  final ReceivePort _port = ReceivePort();
  
  /// Tracks if OrbitTask has been initialized.
  bool _isInitialized = false;
  
  /// Stores the ID of the most recently scheduled task for convenient cancellation.
  String? _lastTaskId;

  @override
  void initState() {
    super.initState();
    
    // Register the port for background communication
    IsolateNameServer.removePortNameMapping('orbit_task_example_log_port');
    IsolateNameServer.registerPortWithName(_port.sendPort, 'orbit_task_example_log_port');
    _port.listen((dynamic data) {
      if (data is String) {
        _log(data);
      }
    });

    // Initialize the background system on startup.
    _initOrbitTask();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('orbit_task_example_log_port');
    _port.close();
    super.dispose();
  }

  /// Initializes the OrbitTask system with the global dispatcher.
  Future<void> _initOrbitTask() async {
    _log('Initializing OrbitTask...');
    try {
      // NOTE: `backgroundDispatcher` must be a static or top-level function.
      await OrbitTask.instance.initialize(dispatcher: backgroundDispatcher);
      setState(() {
        _isInitialized = true;
      });
      _log('OrbitTask Initialized successfully.');
    } catch (e) {
      _log('ERROR: Initialization failed: $e');
    }
  }

  /// Helper to append a timestamped message to the on-screen log.
  void _log(String message) {
    if (!mounted) return;
    setState(() {
      final timestamp = DateFormat('HH:mm:ss').format(DateTime.now());
      _logs.insert(0, '[$timestamp] $message');
    });
  }

  // ---------------------------------------------------------------------------
  // Task Actions
  // ---------------------------------------------------------------------------

  /// Schedules a basic one-time task that requires network connectivity.
  Future<void> _scheduleSimpleOneTime() async {
    _log('Scheduling Simple One-Time Task...');
    try {
      final taskId = await OrbitTask.instance.scheduleOneTime(
        taskName: 'simple_one_time',
        inputData: {
          'scheduled_at': DateTime.now().toIso8601String(),
          'type': 'simple',
        },
        constraints: const TaskConstraints(
          requiresNetwork: true,
        ),
      );
      setState(() => _lastTaskId = taskId);
      _log('Scheduled Task ID: $taskId');
    } catch (e) {
      _log('ERROR: $e');
    }
  }
  
  /// Schedules a complex task requiring both charging and not-low battery.
   Future<void> _scheduleComplexOneTime() async {
    _log('Scheduling Complex One-Time Task (Charging Req)...');
    try {
      final taskId = await OrbitTask.instance.scheduleOneTime(
        taskName: 'complex_task',
        inputData: {
          'payload': 'High priority data',
        },
        constraints: const TaskConstraints(
          requiresCharging: true,
          requiresBatteryNotLow: true,
        ),
      );
      setState(() => _lastTaskId = taskId);
      _log('Scheduled Complex Task ID: $taskId');
    } catch (e) {
      _log('ERROR: $e');
    }
  }

  /// Schedules a recurring task.
  /// Note: The minimum recurring interval on Android is 15 minutes.
  Future<void> _scheduleRecurring() async {
    _log('Scheduling Recurring Task (15 min)...');
    try {
      final taskId = await OrbitTask.instance.scheduleRecurring(
        taskName: 'recurring_maintenance',
        frequency: const Duration(minutes: 15),
        inputData: {'mode': 'maintenance'},
        constraints: const TaskConstraints(
          requiresNetwork: true,
        ),
      );
      setState(() => _lastTaskId = taskId);
      _log('Scheduled Recurring ID: $taskId');
    } catch (e) {
      _log('ERROR: $e');
    }
  }

  Future<void> _cancelLastTask() async {
    if (_lastTaskId == null) {
      _log('No last task ID to cancel.');
      return;
    }
    _log('Cancelling Task ID: $_lastTaskId...');
    try {
      await OrbitTask.instance.cancelTask(_lastTaskId!);
      _log('Task $_lastTaskId cancelled.');
    } catch (e) {
      _log('ERROR: $e');
    }
  }

  Future<void> _cancelAllTasks() async {
    _log('Cancelling ALL tasks...');
    try {
      await OrbitTask.instance.cancelAll();
      _log('All tasks cancelled.');
    } catch (e) {
      _log('ERROR: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // UI Construction
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrbitTask Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => setState(() => _logs.clear()),
            tooltip: 'Clear Logs',
          )
        ],
      ),
      body: Column(
        children: [
          StatusPanel(isInitialized: _isInitialized),
          const Divider(height: 1),
          Expanded(
            child: LogPanel(logs: _logs, scrollController: _logScrollController),
          ),
          const Divider(height: 1),
          ControlPanel(
            isInitialized: _isInitialized,
            onScheduleSimple: _scheduleSimpleOneTime,
            onScheduleComplex: _scheduleComplexOneTime,
            onScheduleRecurring: _scheduleRecurring,
            onCancelLast: _cancelLastTask,
            onCancelAll: _cancelAllTasks,
            onClearLogs: () => setState(() => _logs.clear()),
          ),
        ],
      ),
    );
  }
}
