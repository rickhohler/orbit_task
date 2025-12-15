package com.example.orbit_task_android

import android.content.Context
import androidx.annotation.NonNull
import androidx.work.*
import io.flutter.embedding.engine.Loader
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain
import java.util.concurrent.TimeUnit

/** OrbitTaskAndroidPlugin */
class OrbitTaskAndroidPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  companion object {
    private const val SHARED_PREFERENCES_KEY = "com.example.orbit_task_android.SHARED_PREFERENCES_KEY"
    private const val CALLBACK_DISPATCHER_HANDLE_KEY = "callbackDispatcherHandleKey"

    fun saveCallbackDispatcherHandle(context: Context, handle: Long) {
       context.getSharedPreferences(SHARED_PREFERENCES_KEY, Context.MODE_PRIVATE)
              .edit()
              .putLong(CALLBACK_DISPATCHER_HANDLE_KEY, handle)
              .apply()
    }
    
    fun getCallbackDispatcherHandle(context: Context): Long {
       return context.getSharedPreferences(SHARED_PREFERENCES_KEY, Context.MODE_PRIVATE)
                     .getLong(CALLBACK_DISPATCHER_HANDLE_KEY, 0L)
    }
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "orbit_task")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        "initialize" -> {
            val handle = call.argument<Long>("callbackHandle")
            if (handle != null) {
                saveCallbackDispatcherHandle(context, handle)
                result.success(true)
            } else {
                result.error("INVALID_ARGS", "Callback handle is missing", null)
            }
        }
        "scheduleOneTimeTask" -> {
             val taskName = call.argument<String>("taskName")
             val inputData = call.argument<Map<String, Any>>("inputData") ?: emptyMap()
             val initialDelay = call.argument<Long>("initialDelay") ?: 0L
             
             if (taskName != null) {
                 scheduleOneTimeWork(taskName, inputData, initialDelay)
                 result.success(true)
             } else {
                 result.error("INVALID_ARGS", "Task name is missing", null)
             }
        }
        "scheduleRecurringTask" -> {
             val taskName = call.argument<String>("taskName")
             val inputData = call.argument<Map<String, Any>>("inputData") ?: emptyMap()
             val frequency = call.argument<Int>("frequency")?.toLong() ?: 15L
             
             if (taskName != null) {
                 scheduleRecurringWork(taskName, inputData, frequency)
                 result.success(true)
             } else {
                 result.error("INVALID_ARGS", "Task name is missing", null)
             }
        }
        "cancelTask" -> {
             val taskId = call.argument<String>("taskId")
             if (taskId != null) {
                 WorkManager.getInstance(context).cancelUniqueWork(taskId)
                 result.success(true)
             } else {
                 result.error("INVALID_ARGS", "Task ID is missing", null)
             }
        }
        "cancelAllTasks" -> {
            WorkManager.getInstance(context).cancelAllWork()
            result.success(true)
        }
        else -> {
            result.notImplemented()
        }
    }
  }

  private fun scheduleOneTimeWork(taskName: String, inputData: Map<String, Any>, initialDelay: Long) {
      val dataBuilder = Data.Builder()
      inputData.forEach { (key, value) ->
          when (value) {
              is String -> dataBuilder.putString(key, value)
              is Int -> dataBuilder.putInt(key, value)
              is Long -> dataBuilder.putLong(key, value)
              is Boolean -> dataBuilder.putBoolean(key, value)
              is Double -> dataBuilder.putDouble(key, value)
              // Note: WorkManager Data has size limits.
          }
      }
      dataBuilder.putString("orbit_task_name", taskName)

      val workRequest = OneTimeWorkRequest.Builder(OrbitTaskWorker::class.java)
          .setInitialDelay(initialDelay, TimeUnit.MILLISECONDS)
          .setInputData(dataBuilder.build())
          .addTag(taskName) // Use taskName as tag
          .build()

      WorkManager.getInstance(context).enqueueUniqueWork(
          taskName,
          ExistingWorkPolicy.REPLACE,
          workRequest
      )
  }

  private fun scheduleRecurringWork(taskName: String, inputData: Map<String, Any>, frequencyMinutes: Long) {
      val dataBuilder = Data.Builder()
      inputData.forEach { (key, value) ->
          when (value) {
              is String -> dataBuilder.putString(key, value)
              is Int -> dataBuilder.putInt(key, value)
              is Long -> dataBuilder.putLong(key, value)
              is Boolean -> dataBuilder.putBoolean(key, value)
              is Double -> dataBuilder.putDouble(key, value)
          }
      }
      dataBuilder.putString("orbit_task_name", taskName)

      val workRequest = PeriodicWorkRequest.Builder(OrbitTaskWorker::class.java, frequencyMinutes, TimeUnit.MINUTES)
          .setInputData(dataBuilder.build())
          .addTag(taskName)
          .build()

      WorkManager.getInstance(context).enqueueUniquePeriodicWork(
          taskName,
          ExistingPeriodicWorkPolicy.UPDATE,
          workRequest
      )
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

