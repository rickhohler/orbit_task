import 'dart:async';
import 'dart:developer' as developer;
import 'dart:isolate';
import 'package:uuid/uuid.dart';
import 'package:orbit_task_platform_interface/orbit_task_platform_interface.dart';

/// Facade for managing background tasks across platforms.
///
/// This class provides a simplified interface for scheduling and managing tasks,
/// delegating the actual platform-specific work to the configured [OrbitTaskPlatform].
class OrbitTask {
  static final OrbitTask _instance = OrbitTask._internal();
  static OrbitTask get instance => _instance;

  Function? _dispatcher;
  final Map<String, Future<TaskResult> Function(Map<String, dynamic>)>
  _taskHandlers = {};
  bool _isInitialized = false;
  final _uuid = Uuid();

  OrbitTask._internal();

  /// Configure the scheduler.
  ///
  /// [dispatcher]: Optional top-level function that registers task handlers.
  ///               Required if using isolate-based execution on Mobile.
  /// Note: The platform channel must be configured before calling this,
  /// typically via standard plugin registration.
  Future<void> initialize({Function? dispatcher}) async {
    _dispatcher = dispatcher;
    await OrbitTaskPlatform.instance.initialize(
      _executeTask,
      dispatcher: dispatcher,
    );
    _isInitialized = true;
  }

  /// Register a handler for a task name.
  void registerHandler(
    String taskName,
    Future<TaskResult> Function(Map<String, dynamic>) handler,
  ) {
    _taskHandlers[taskName] = handler;
  }

  /// Schedule a task.
  Future<void> scheduleTask(BackgroundTask task) async {
    _checkInitialized();
    if (task.frequency != null) {
      await OrbitTaskPlatform.instance.scheduleRecurringTask(task);
    } else {
      await OrbitTaskPlatform.instance.scheduleOneTimeTask(task);
    }
  }

  /// Quick helper to schedule a simple one-time task.
  Future<String> scheduleOneTime({
    required String taskName,
    Map<String, dynamic> inputData = const {},
    TaskConstraints constraints = const TaskConstraints(),
  }) async {
    final id = _uuid.v4();
    final task = BackgroundTask(
      id: id,
      taskName: taskName,
      inputData: inputData,
      constraints: constraints,
    );
    await scheduleTask(task);
    return id;
  }

  /// Cancel a task.
  Future<void> cancelTask(String taskId) async {
    _checkInitialized();
    await OrbitTaskPlatform.instance.cancelTask(taskId);
  }

  /// Cancel all tasks.
  Future<void> cancelAll() async {
    _checkInitialized();
    await OrbitTaskPlatform.instance.cancelAllTasks();
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError("OrbitTask not initialized. Call initialize() first.");
    }
  }

  /// Internal callback executed by the strategy when a task fires.
  void _executeTask(String taskName, Map<String, dynamic> inputData) async {
    // it calls this _executeTask.

    // For standard non-isolate flow:
    await executeTaskInternally(taskName, inputData);
  }

  /// Public helper to execute a task by name (used by IsolateTaskRunner).
  Future<void> executeTaskInternally(
    String taskName,
    Map<String, dynamic> inputData,
  ) async {
    final handler = _taskHandlers[taskName];
    if (handler != null) {
      try {
        await handler(inputData);
      } catch (e) {
        developer.log("Task execution failed for $taskName", error: e);
      }
    } else {
      developer.log(
        "No handler registered for task: $taskName. (Isolate: ${Isolate.current.debugName})",
      );
    }
  }

  /// Get the registered dispatcher.
  Function? get dispatcher => _dispatcher;
}
