// ignore_for_file: avoid_print
import 'dart:ui';
import 'dart:isolate';
import 'package:orbit_task/orbit_task.dart';
import 'sieve_algorithm.dart';

// -----------------------------------------------------------------------------
// Background Entry Point
// -----------------------------------------------------------------------------

/// The top-level entry point for background execution.
@pragma('vm:entry-point')
void backgroundDispatcher() {
  // Helper to send logs back to the main UI isolate
  void sendLog(String msg) {
    print(msg); // Keep console print for debugging
    final SendPort? sendPort = IsolateNameServer.lookupPortByName('orbit_task_example_log_port');
    if (sendPort != null) {
      sendPort.send('[BG] $msg');
    } else {
      print('>>> [Background] Could not find UI port.');
    }
  }

  // Handler for 'simple_one_time' tasks.
  OrbitTask.instance.registerHandler('simple_one_time', (inputData) async {
    sendLog('Executing Simple One-Time Task (Sieve). Data: $inputData');
    
    final stopwatch = Stopwatch()..start();
    final primes = performSieve(max: 10000);
    stopwatch.stop();

    sendLog('Sieve Completed in ${stopwatch.elapsedMilliseconds}ms. Found ${primes.length} primes.');
    return TaskResult.success();
  });

  // Handler for 'recurring_maintenance' tasks.
  OrbitTask.instance.registerHandler('recurring_maintenance', (inputData) async {
    sendLog('Executing Recurring Maintenance. Data: $inputData');
    return TaskResult.success();
  });
  
  // Handler for 'complex_task' tasks.
  OrbitTask.instance.registerHandler('complex_task', (inputData) async {
    sendLog('Executing Complex Task. Data: $inputData');
    return TaskResult.success();
  });
}

