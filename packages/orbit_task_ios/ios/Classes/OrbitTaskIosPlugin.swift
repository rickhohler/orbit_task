import Flutter
import UIKit
import BackgroundTasks

public class OrbitTaskIosPlugin: NSObject, FlutterPlugin {
  
  static let callbackHandleKey = "orbit_task_callback_handle"
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "orbit_task", binaryMessenger: registrar.messenger())
    let instance = OrbitTaskIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
        if let args = call.arguments as? [String: Any],
           let handle = args["callbackHandle"] as? Int64 {
            UserDefaults.standard.set(handle, forKey: OrbitTaskIosPlugin.callbackHandleKey)
            result(true)
        } else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing callbackHandle", details: nil))
        }
    case "scheduleOneTimeTask":
        if let args = call.arguments as? [String: Any],
           let taskIdentifier = args["taskName"] as? String {
             // Input data storage: BGTask doesn't support generic user info payload well for "inputData" reuse 
             // between scheduling and execution easily without custom persistence.
             // For now we persist input data to UserDefaults keyed by taskIdentifier logic.
             if let inputData = args["inputData"] as? [String: Any] {
                 UserDefaults.standard.set(inputData, forKey: "orbit_task_data_\(taskIdentifier)")
             }
             
             self.scheduleAppRefresh(identifier: taskIdentifier)
             result(true)
        } else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing taskName", details: nil))
        }
    case "scheduleRecurringTask":
        if let args = call.arguments as? [String: Any],
           let taskIdentifier = args["taskName"] as? String {
             // Save input data
             if let inputData = args["inputData"] as? [String: Any] {
                 UserDefaults.standard.set(inputData, forKey: "orbit_task_data_\(taskIdentifier)")
             }

             self.scheduleAppRefresh(identifier: taskIdentifier)
             result(true)
        } else {
             result(FlutterError(code: "INVALID_ARGS", message: "Missing taskName", details: nil))
        }
    case "cancelTask":
        if let args = call.arguments as? [String: Any],
           let taskId = args["taskId"] as? String {
             BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskId)
             result(true)
        }
    case "cancelAllTasks":
        BGTaskScheduler.shared.cancelAllTaskRequests()
        result(true)
    default:
        result(FlutterMethodNotImplemented)
    }
  }

  func scheduleAppRefresh(identifier: String) {
     let request = BGAppRefreshTaskRequest(identifier: identifier)
     request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 mins minimum
     
     do {
        try BGTaskScheduler.shared.submit(request)
     } catch {
        print("OrbitTask: Could not schedule app refresh for \(identifier): \(error)")
     }
  }

  // Define a static helper for AppDelegate to call
  // OrbitTaskIosPlugin.registerBackgroundTasks(identifiers: ["com.my.task"])
  public static func registerBackgroundTasks(identifiers: [String]) {
      for id in identifiers {
          BGTaskScheduler.shared.register(forTaskWithIdentifier: id, using: nil) { task in
              if let refreshTask = task as? BGAppRefreshTask {
                  OrbitTaskIosPlugin.handleAppRefresh(task: refreshTask)
              }
          }
      }
  }

  // Global handler for tasks
  static func handleAppRefresh(task: BGAppRefreshTask) {
     let identifier = task.identifier
     
     // 1. Reschedule logic (if recurring strategy desired, implementation dependent)
     // wrapper.scheduleAppRefresh(identifier: identifier) 
     
     // 2. Setup Expiration
     task.expirationHandler = {
        task.setTaskCompleted(success: false)
     }

     // 3. Run Dart
     let defaults = UserDefaults.standard
     guard let callbackHandle = defaults.object(forKey: OrbitTaskIosPlugin.callbackHandleKey) as? Int64 else {
         print("OrbitTask: No callback handle found.")
         task.setTaskCompleted(success: false)
         return
     }
     
     // Retrieve input data
     let inputData = defaults.dictionary(forKey: "orbit_task_data_\(identifier)") ?? [:]
     
     guard let flutterCallbackInfo = FlutterCallbackCache.lookupCallbackInformation(callbackHandle) else {
         print("OrbitTask: Could not lookup callback information.")
         task.setTaskCompleted(success: false)
         return
     }
     
     // CRITICAL FIX: FlutterEngine must be initialized on the Main Thread.
     // Reverting to GCD (DispatchQueue) to avoid Swift Concurrency 'unsafeForcedSync' warnings.
     DispatchQueue.main.async {
         let engine = FlutterEngine(name: "OrbitTaskHeadless", project: nil)
         print("after engine")
         let success = engine.run(withEntrypoint: flutterCallbackInfo.callbackName, libraryURI: flutterCallbackInfo.callbackLibraryPath)
         print("after run: \(success)")
         if !success {
             print("OrbitTask: Failed to run headless engine.")
             task.setTaskCompleted(success: false)
             return
         }
         
         // Register background channel on this new headless engine
         let channel = FlutterMethodChannel(name: "orbit_task_background", binaryMessenger: engine.binaryMessenger)
         
         // We define a completion handler to wait for Dart side
         var isCompleted = false
         
         channel.invokeMethod("executeTask", arguments: ["taskName": identifier, "inputData": inputData]) { result in
             isCompleted = true
             task.setTaskCompleted(success: true)
             // Keep engine alive until completion if needed, or destroy here?
             // Usually good practice to keep it alive until task finishes.
             engine.destroyContext() 
         }
         
         // Timeout safety if Dart doesn't return
         DispatchQueue.main.asyncAfter(deadline: .now() + 29) { // < 30s limit
             if !isCompleted {
                 // Ensure we mark complete so system doesn't kill us poorly
                 task.setTaskCompleted(success: false)
                 engine.destroyContext()
             }
         }
     }
  }
}
