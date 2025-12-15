import 'dart:isolate';
import 'orbit_task.dart';

/// Runner for tasks in a separate isolate.
///
/// This isolates the execution of a task from the main thread.
class IsolateTaskRunner {
  /// Execute a task in a separate isolate.
  ///
  /// [dispatcher] must be a top-level function that sets up the task handling.
  /// [taskName] and [inputData] are passed to the dispatcher mechanism.
  static Future<void> executeTask({
    required Function dispatcher,
    required String taskName,
    required Map<String, dynamic> inputData,
  }) async {
    final port = ReceivePort();

    // Check if dispatcher is valid (static/top-level) happens via spawn
    try {
      await Isolate.spawn(
        _isolateEntry,
        _IsolatePayload(
          sendPort: port.sendPort,
          dispatcher: dispatcher,
          taskName: taskName,
          inputData: inputData,
        ),
      );

      // Wait for completion signal
      final result = await port.first;
      if (result is _IsolateError) {
        throw Exception("Isolate execution failed: ${result.error}");
      }
    } catch (e) {
      rethrow;
    }
  }

  static void _isolateEntry(_IsolatePayload payload) async {
    final sendPort = payload.sendPort;

    try {
      // 1. Run the dispatcher. This should configure the TaskScheduler
      //    in this new isolate with handlers.
      //    The dispatcher must be void Function().
      if (payload.dispatcher is void Function()) {
        (payload.dispatcher as void Function())();
      } else {
        throw ArgumentError("Dispatcher must be a void Function()");
      }

      // 2. Execute the specific task
      //    The dispatcher should have called `OrbitTask.instance.registerHandler`.
      //    Unintuitively, we need access to the OrbitTask instance IN THIS ISOLATE.
      //    Since OrbitTask is a singleton, `OrbitTask.instance` here is distinct
      //    from the main isolate. It is empty until handlers are registered.

      // We manually invoke the private execution logic on the local instance.
      // But we need to expose it or simulate it.
      // We can use a public helper methods on OrbitTask.

      await OrbitTask.instance.executeTaskInternally(
        payload.taskName,
        payload.inputData,
      );

      sendPort.send(true); // Success
    } catch (e) {
      sendPort.send(_IsolateError(e.toString()));
    } finally {
      Isolate.exit(sendPort);
    }
  }
}

class _IsolatePayload {
  final SendPort sendPort;
  final Function dispatcher;
  final String taskName;
  final Map<String, dynamic> inputData;

  _IsolatePayload({
    required this.sendPort,
    required this.dispatcher,
    required this.taskName,
    required this.inputData,
  });
}

class _IsolateError {
  final String error;
  _IsolateError(this.error);
}
