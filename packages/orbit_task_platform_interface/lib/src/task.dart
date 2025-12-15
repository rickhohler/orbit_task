/// Represents a task to be executed in the background.
///
/// Follows the Command pattern structure, encapsulating the data needed
/// to execute a task.
class BackgroundTask {
  /// Unique identifier for the task.
  final String id;

  /// Name of the task (used for registration/dispatch).
  final String taskName;

  /// Input data for the task.
  final Map<String, dynamic> inputData;

  /// Execution frequency (if recurring). Null for one-time.
  final Duration? frequency;

  /// Constraints for the task.
  final TaskConstraints constraints;

  BackgroundTask({
    required this.id,
    required this.taskName,
    this.inputData = const {},
    this.frequency,
    this.constraints = const TaskConstraints(),
  });
}

/// Constraints for background execution.
class TaskConstraints {
  final bool requiresNetwork;
  final bool requiresCharging;
  final bool requiresBatteryNotLow;
  final bool requiresDeviceIdle;
  final bool requiresStorageNotLow;

  const TaskConstraints({
    this.requiresNetwork = false,
    this.requiresCharging = false,
    this.requiresBatteryNotLow = false,
    this.requiresDeviceIdle = false,
    this.requiresStorageNotLow = false,
  });
}

/// Result of a background task execution.
class TaskResult {
  final bool success;
  final Object? error;

  TaskResult.success() : success = true, error = null;
  TaskResult.failure(this.error) : success = false;
}
