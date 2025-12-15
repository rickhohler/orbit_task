package com.example.orbit_task_android

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.work.Worker
import androidx.work.WorkerParameters
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.view.FlutterCallbackInformation
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch

class OrbitTaskWorker(private val context: Context, workerParams: WorkerParameters) : Worker(context, workerParams) {

    override fun doWork(): Result {
        val taskName = inputData.getString("orbit_task_name") ?: return Result.failure()
        
        // We need to pass all input data back to Dart
        val dartArgs = inputData.keyValueMap

        // Get the callback handle
        val callbackHandle = OrbitTaskAndroidPlugin.getCallbackDispatcherHandle(context)
        if (callbackHandle == 0L) {
            return Result.failure()
        }

        val latch = CountDownLatch(1)
        var success = false

        // We must run Flutter Engine initialization on the main thread
        Handler(Looper.getMainLooper()).post {
            try {
                val flutterEngine = FlutterEngine(context)
                
                val flutterCallbackInfo = FlutterCallbackInformation.lookupCallbackInformation(callbackHandle)
                val dartBundlePath = FlutterInjector.instance().flutterLoader().findAppBundlePath()
                
                if (flutterCallbackInfo == null) {
                    latch.countDown()
                    return@post
                }
                
                val dartCallback = DartExecutor.DartCallback(
                    context.assets,
                    dartBundlePath,
                    flutterCallbackInfo
                )

                flutterEngine.dartExecutor.executeDartCallback(dartCallback)

                // Establish a Background Method Channel for this specific worker execution
                // Note: The Dispatcher in Dart MUST listen on this channel name as well.
                // Or we can re-use the main channel if the dispatcher sets it up.
                // Usually dispatchers set up a MethodCallHandler.
                
                val backgroundChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "orbit_task_background")
                
                backgroundChannel.invokeMethod("executeTask", mapOf(
                    "taskName" to taskName,
                    "inputData" to dartArgs
                ), object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        success = true
                        latch.countDown()
                        flutterEngine.destroy()
                    }

                    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                        latch.countDown()
                        flutterEngine.destroy()
                    }

                    override fun notImplemented() {
                        latch.countDown()
                        flutterEngine.destroy()
                    }
                })

            } catch (e: Exception) {
                e.printStackTrace()
                latch.countDown()
            }
        }

        try {
            latch.await()
        } catch (e: InterruptedException) {
            return Result.retry()
        }

        return if (success) Result.success() else Result.failure()
    }
}
