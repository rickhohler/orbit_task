package com.example.orbit_task

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** OrbitTaskPlugin */
class OrbitTaskPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "orbit_task")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        "scheduleOneTimeTask" -> {
            val taskName = call.argument<String>("taskName")
            // TODO: Implement native JobScheduler or WorkManager directly if desired,
            // or keep this as a clean slate for custom implementation.
             result.success(true)
        }
        "scheduleRecurringTask" -> {
             // TODO: Implement recurring logic
             result.success(true)
        }
        "cancelTask" -> {
            // TODO: Implement cancellation
            result.success(true)
        }
        "cancelAllTasks" -> {
            // TODO: Implement cancel all
            result.success(true)
        }
        else -> {
            result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
