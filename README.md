# OrbitTask 🪐

**The Next Generation Task Scheduler for Flutter.**

OrbitTask is engineered to seamlessly orchestrate background execution across the entire platform ecosystem. Beyond simple job scheduling, OrbitTask provides a unified, asteroid-proof API that abstracts away the complexities of native background processing.

## 🚀 Features

*   **Unified API**: Write your task logic once, run it anywhere (Android, iOS, Web).
*   **Persistent Execution**: Uses native background APIs (WorkManager on Android, BGTaskScheduler on iOS) to ensure jobs run even when the app is terminated.
*   **Web Support**: Seamlessly falls back to Timer-based scheduling on Web (WASM compatible).
*   **Isolate Powered**: Offloads heavy lifting to background isolates to keep your UI frame-perfect.
*   **Constraint-Based**: Schedule tasks that only run when conditions are met (e.g., Device Charging, Network Connected).
*   **Zero External Dependencies**: Built from the ground up for maximum control and performance.

## 📱 Platform Support & Limitations

| Platform | True Background Execution | Native Tech Stack | Features | Limitations |
| :--- | :--- | :--- | :--- | :--- |
| **Android** | ✅ **Yes** (Even if app terminated) | `WorkManager` (Kotlin) | Robust persistence, boot recovery, constraint-based execution (Network, Charging). | Minimum periodic interval is 15 minutes. Execution timing depends on OS battery optimizations. |
| **iOS** | ✅ **Yes** (Strict System Rules) | `BGTaskScheduler` (Swift) | Efficient system-managed execution, battery friendly. | System decides exact execution time. Requires `Info.plist` configuration. May not run if User Force Quits app. |
| **Web** | ❌ **No** (Tab must be open) | `dart:async` / `Timer` | Standard Javascript-style event loop scheduling. WASM compatible. | Execution stops immediately when tab is closed or backgrounded (browser dependent). |

## 📦 Architecture

OrbitTask uses a federated plugin architecture:
*   **Core**: `OrbitTask` facade for easy API usage.
*   **Platform Interface**: `OrbitTaskPlatform` for establishing contracts.
*   **Android**: Custom `orbit_task_android` package wrapping `WorkManager`.
*   **iOS**: Custom `orbit_task_ios` package wrapping `BGTaskScheduler`.
*   **Web**: Lightweight `orbit_task_web` package using native Dart Timers.

## 🛠️ Usage

```dart
// 1. Define a top-level dispatcher
@pragma('vm:entry-point')
void callbackDispatcher() {
  // Initialize and handle background events
}

// 2. Or use the Annotation API
@orbitTask
Future<void> myBackgroundTask(Map<String, dynamic> args) async {
  print("Running background task!");
}

void main() async {
  // 3. Initialize OrbitTask
  await OrbitTask.instance.initialize(
    dispatcher: callbackDispatcher
  );

  // 4. Schedule via Facade
  await OrbitTask.instance.scheduleOneTime(
    taskName: "sync_heavy_data",
    constraints: TaskConstraints(requiresNetwork: true),
  );
}
```

## 🔮 Experimental: Code Generation
OrbitTask now supports code generation to simplify task registration!
1. Add `orbit_task_annotations` and `orbit_task_generator`.
2. Annotate your top-level functions with `@orbitTask`.
3. Run `dart run build_runner build`.
This mechanism will eventually automate the boilerplate of `callbackDispatcher`.

## 🌟 Why OrbitTask?

Existing solutions often force you to choose between robust native persistence and cross-platform flexibility. OrbitTask gives you both. It is designed from the ground up to be the default choice for modern Flutter applications that demand reliability without the boilerplate.
