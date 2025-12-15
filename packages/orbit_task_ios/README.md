# OrbitTask iOS

The iOS implementation for `orbit_task`. This package provides `BGTaskScheduler` integration.

## Setup Requirements

### 1. Info.plist

You must add the `BGTaskSchedulerPermittedIdentifiers` key to your `Info.plist`. This is a list of strings representing the task names you intend to use.

```xml
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
    <string>com.yourcompany.task1</string>
    <string>com.yourcompany.task2</string>
</array>
```

### 2. AppDelegate Registration

You must register these identifiers in your `AppDelegate.swift` (or `AppDelegate.m`) *before* the application finishes launching.

**Swift Example:**

```swift
import UIKit
import Flutter
import orbit_task_ios // Ensure this import is available

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Register your background tasks
    if #available(iOS 13.0, *) {
        OrbitTaskIosPlugin.registerBackgroundTasks(identifiers: ["com.yourcompany.task1", "com.yourcompany.task2"])
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Capabilities
Ensure you have enabled **Background Modes** -> **Background fetch** and **Background processing** in your Xcode project capabilities.
