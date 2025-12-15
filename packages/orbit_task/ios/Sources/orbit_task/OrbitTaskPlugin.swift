import Flutter
import UIKit
import BackgroundTasks

public class OrbitTaskPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "orbit_task", binaryMessenger: registrar.messenger())
    let instance = OrbitTaskPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    // Register background task identifier
    // In a real app, this ID must match Info.plist
    // BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.orbit_task.refresh", using: nil) { task in
    //     instance.handleAppRefresh(task: task as! BGAppRefreshTask)
    // }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "scheduleOneTimeTask":
        if let args = call.arguments as? [String: Any],
           let taskName = args["taskName"] as? String {
             // Schedule BGTask
             self.scheduleTask(identifier: taskName)
             result(true)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing taskName", details: nil))
        }
    default:
        result(FlutterMethodNotImplemented)
    }
  }
  
  private func scheduleTask(identifier: String) {
      let request = BGProcessingTaskRequest(identifier: identifier)
      request.requiresNetworkConnectivity = true
      
      do {
          try BGTaskScheduler.shared.submit(request)
      } catch {
          print("Could not schedule app refresh: \(error)")
      }
  }
}
