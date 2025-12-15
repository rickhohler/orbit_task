import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:orbit_task_platform_interface/orbit_task_platform_interface.dart';

/// The Android implementation of [OrbitTaskPlatform].
class OrbitTaskAndroid extends OrbitTaskPlatform {
  /// The method channel used to interact with the native platform.
  final MethodChannel _channel = const MethodChannel('orbit_task');

  /// The method channel used to receive background events.
  final MethodChannel _backgroundChannel = const MethodChannel(
    'orbit_task_background',
  );

  /// Registers this class as the default instance of [OrbitTaskPlatform].
  static void registerWith() {
    OrbitTaskPlatform.instance = OrbitTaskAndroid();
  }

  void Function(String, Map<String, dynamic>)? _taskExecutor;

  @override
  Future<void> initialize(
    void Function(String, Map<String, dynamic>) taskExecutor, {
    Function? dispatcher,
  }) async {
    _taskExecutor = taskExecutor;

    // Set up the background channel handler if we are in the background isolate
    // We can guess we are in background if we are called from the dispatcher essentially.
    _backgroundChannel.setMethodCallHandler(_handleBackgroundMethodCall);

    if (dispatcher != null) {
      final CallbackHandle? callback = PluginUtilities.getCallbackHandle(
        dispatcher,
      );
      if (callback != null) {
        final int handle = callback.toRawHandle();
        await _channel.invokeMethod('initialize', {'callbackHandle': handle});
      } else {
        throw Exception(
          "Could not find callback handle for dispatcher. Ensure it is a top-level function or static method.",
        );
      }
    }
  }

  Future<dynamic> _handleBackgroundMethodCall(MethodCall call) async {
    if (call.method == "executeTask") {
      final String taskName = call.arguments['taskName'];
      final Map<dynamic, dynamic> inputDataArg =
          call.arguments['inputData'] ?? {};
      final Map<String, dynamic> inputData = Map<String, dynamic>.from(
        inputDataArg,
      );

      if (_taskExecutor != null) {
        _taskExecutor!(taskName, inputData);
      } else {
        debugPrint("OrbitTaskAndroid: Task executor not set.");
      }
    }
  }

  @override
  Future<void> scheduleOneTimeTask(BackgroundTask task) async {
    await _channel.invokeMethod('scheduleOneTimeTask', {
      'taskName': task.taskName,
      'inputData': task.inputData,
      'initialDelay': 0,
    });
  }

  @override
  Future<void> scheduleRecurringTask(BackgroundTask task) async {
    await _channel.invokeMethod('scheduleRecurringTask', {
      'taskName': task.taskName,
      'frequency': task.frequency?.inMinutes ?? 15,
      'inputData': task.inputData,
    });
  }

  @override
  Future<void> cancelTask(String taskId) async {
    await _channel.invokeMethod('cancelTask', {'taskId': taskId});
  }

  @override
  Future<void> cancelAllTasks() async {
    await _channel.invokeMethod('cancelAllTasks');
  }
}
