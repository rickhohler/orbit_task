import 'dart:async';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:orbit_task_platform_interface/orbit_task_platform_interface.dart';

/// A web implementation of the OrbitTaskPlatform of the OrbitTask plugin.
class OrbitTaskWebWeb extends OrbitTaskPlatform {
  /// Constructs a OrbitTaskWebWeb
  OrbitTaskWebWeb();

  static void registerWith(Registrar registrar) {
    OrbitTaskPlatform.instance = OrbitTaskWebWeb();
  }

  final Map<String, Timer> _activeTimers = {};
  late void Function(String, Map<String, dynamic>) _executor;

  @override
  Future<void> initialize(
    void Function(String, Map<String, dynamic>) taskExecutor, {
    Function? dispatcher,
  }) async {
    _executor = taskExecutor;
  }

  @override
  Future<void> scheduleOneTimeTask(BackgroundTask task) async {
     // Web doesn't support "background" in the same sense as mobile when the tab is closed.
     // We use a simple Timer simulation.
     Timer(const Duration(milliseconds: 100), () async {
       await _runTask(task);
     });
  }

  Future<void> _runTask(BackgroundTask task) async {
    // On web, we run on the main thread (event loop) directly.
    // WASM isolates are possible but complex to setup purely here without worker files.
    _executor(task.taskName, task.inputData);
  }

  @override
  Future<void> scheduleRecurringTask(BackgroundTask task) async {
    final frequency = task.frequency ?? const Duration(minutes: 15);
    _cancelTimer(task.id);
    
    _activeTimers[task.id] = Timer.periodic(frequency, (_) {
      _runTask(task);
    });
  }

  @override
  Future<void> cancelTask(String taskId) async {
    _cancelTimer(taskId);
  }

  @override
  Future<void> cancelAllTasks() async {
    for (var timer in _activeTimers.values) {
      timer.cancel();
    }
    _activeTimers.clear();
  }

  void _cancelTimer(String id) {
    _activeTimers[id]?.cancel();
    _activeTimers.remove(id);
  }
}
