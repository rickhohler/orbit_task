/// Runner for tasks (stub for non-IO platforms).
class IsolateTaskRunner {
  /// Execute a task in a separate isolate.
  static Future<void> executeTask({
    required Function dispatcher,
    required String taskName,
    required Map<String, dynamic> inputData,
  }) async {
    throw UnimplementedError(
      "IsolateTaskRunner is not supported on this platform.",
    );
  }
}
