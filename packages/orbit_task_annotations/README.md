# orbit_task_annotations

Annotation library for the `orbit_task` plugin.

## Usage

This package provides the `@orbitTask` annotation used to mark static top-level functions for background execution.

```dart
import 'package:orbit_task_annotations/orbit_task_annotations.dart';

@orbitTask
void myBackgroundFunction(String taskName, Map<String, dynamic> data) {
  print("Task $taskName executd!");
}
```
