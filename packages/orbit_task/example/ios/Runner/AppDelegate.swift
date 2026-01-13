import Flutter
import UIKit
import orbit_task_ios

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register background task identifiers BEFORE the app finishes launching.
    // Ideally this matches Info.plist.
    OrbitTaskIosPlugin.registerBackgroundTasks(identifiers: [
        "simple_one_time",
        "recurring_maintenance",
        "complex_task"
    ])
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
