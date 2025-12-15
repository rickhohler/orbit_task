import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'src/task.dart';

export 'src/task.dart';

/// The interface that implementations of orbit_task must implement.
///
/// Platform implementations should extend this class rather than implement it as `interface`.
/// Extending this class (using `extends`) ensures that the subclass will get the default implementation,
/// while platform implementations that `implements` this interface will be broken by newly added
/// [OrbitTaskPlatform] methods.
abstract class OrbitTaskPlatform extends PlatformInterface {
  /// Constructs a OrbitTaskPlatform.
  OrbitTaskPlatform() : super(token: _token);

  static final Object _token = Object();

  static OrbitTaskPlatform _instance = _PlaceholderImplementation();

  /// The default instance of [OrbitTaskPlatform] to use.
  ///
  /// Defaults to [_PlaceholderImplementation].
  static OrbitTaskPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OrbitTaskPlatform] when
  /// they register themselves.
  static set instance(OrbitTaskPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initialize the platform scheduler.
  Future<void> initialize(
    void Function(String, Map<String, dynamic>) taskExecutor, {
    Function? dispatcher,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  /// Schedule a one-time task.
  Future<void> scheduleOneTimeTask(BackgroundTask task) {
    throw UnimplementedError('scheduleOneTimeTask() has not been implemented.');
  }

  /// Schedule a recurring task.
  Future<void> scheduleRecurringTask(BackgroundTask task) {
    throw UnimplementedError('scheduleRecurringTask() has not been implemented.');
  }

  /// Cancel a specific task.
  Future<void> cancelTask(String taskId) {
    throw UnimplementedError('cancelTask() has not been implemented.');
  }

  /// Cancel all tasks.
  Future<void> cancelAllTasks() {
    throw UnimplementedError('cancelAllTasks() has not been implemented.');
  }
}

class _PlaceholderImplementation extends OrbitTaskPlatform {}
