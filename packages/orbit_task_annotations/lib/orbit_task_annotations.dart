/// Annotation to define an OrbitTask.
///
/// Use this to annotate functions that should be treated as background tasks.
///
/// Example:
/// ```dart
/// @orbitTask
/// Future<void> myBackgroundTask(Map<String, dynamic> args) async {
///   print("Task running!");
/// }
/// ```
class OrbitTaskAnnotation {
  const OrbitTaskAnnotation();
}

/// Constant instance for the annotation
const orbitTask = OrbitTaskAnnotation();
