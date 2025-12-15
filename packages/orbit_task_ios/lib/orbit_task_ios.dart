import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:orbit_task_platform_interface/orbit_task_platform_interface.dart';

/// The iOS implementation of [OrbitTaskPlatform].
class OrbitTaskIos extends OrbitTaskPlatform {
  /// The method channel used to interact with the native platform.
  final MethodChannel _channel = const MethodChannel('orbit_task');

  /// Registers this class as the default instance of [OrbitTaskPlatform].
  static void registerWith() {
    OrbitTaskPlatform.instance = OrbitTaskIos();
  }

  @override
  Future<void> initialize(
    void Function(String, Map<String, dynamic>) taskExecutor, {
    Function? dispatcher,
  }) async {
    // For iOS headless execution, we need to pass the callback handle if available.
    if (dispatcher != null) {
      final int? handle = PluginUtilities.getCallbackHandle(dispatcher)?.toRawHandle();
      if (handle != null) {
        await _channel.invokeMethod('initialize', {'callbackHandle': handle});
      }
    }
  }

  @override
  Future<void> scheduleOneTimeTask(BackgroundTask task) async {
    await _channel.invokeMethod('scheduleOneTimeTask', {
      'taskName': task.taskName,
      'inputData': task.inputData,
    });
  }

  @override
  Future<void> scheduleRecurringTask(BackgroundTask task) async {
    // iOS treats recurring as just re-scheduling, handled on native side primarily.
    await _channel.invokeMethod('scheduleRecurringTask', {
      'taskName': task.taskName,
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
