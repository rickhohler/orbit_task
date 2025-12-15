import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_task/src/orbit_task_web.dart';
import 'package:orbit_task/src/task.dart';
import 'package:orbit_task/orbit_task_platform_interface.dart';
import 'dart:async';

void main() {
  group('OrbitTaskWeb', () {
    late OrbitTaskWeb webPlatform;

    setUp(() {
      webPlatform = OrbitTaskWeb();
    });

    test('is registered instance', () {
      OrbitTaskWeb.registerWith(null as dynamic); // Registrar ignored in logic
      expect(OrbitTaskPlatform.instance, isA<OrbitTaskWeb>());
    });

    test('scheduleOneTimeTask executes task after delay', () async {
      final task = BackgroundTask(
        id: 'web_task_1',
        taskName: 'simple_task',
        inputData: {'foo': 'bar'},
      );

      final completer = Completer<void>();
      var executed = false;

      // Initialize with executor
      await webPlatform.initialize((taskName, inputData) {
        if (taskName == 'simple_task' && inputData['foo'] == 'bar') {
          executed = true;
          completer.complete();
        }
      });

      await webPlatform.scheduleOneTimeTask(task);

      // Wait for execution (simulated delay is 100ms)
      await completer.future.timeout(const Duration(seconds: 1));

      expect(executed, isTrue);
    });

    test('scheduleRecurringTask executes repeatedly', () async {
      final task = BackgroundTask(
        id: 'recur_task_1',
        taskName: 'periodic',
        inputData: {},
        frequency: const Duration(milliseconds: 50), // Fast frequency for test
      );

      int count = 0;
      await webPlatform.initialize((taskName, inputData) {
        if (taskName == 'periodic') {
          count++;
        }
      });

      await webPlatform.scheduleRecurringTask(task);

      // Wait for 2-3 cycles
      await Future.delayed(const Duration(milliseconds: 200));

      await webPlatform.cancelTask(task.id);

      expect(count, greaterThanOrEqualTo(2));
    });

    test('cancelTask cancels recurring task', () async {
      final task = BackgroundTask(
        id: 'cancel_me',
        taskName: 'periodic',
        inputData: {},
        frequency: const Duration(milliseconds: 50),
      );

      int count = 0;
      await webPlatform.initialize((taskName, inputData) {
        count++;
      });

      await webPlatform.scheduleRecurringTask(task);
      await Future.delayed(
        const Duration(milliseconds: 50),
      ); // let it run once potentially
      await webPlatform.cancelTask(task.id);

      final countAfterCancel = count;
      await Future.delayed(const Duration(milliseconds: 150)); // wait more

      // Should not have incremented significantly more after cancel
      // (allowing for 1 race condition firing due to timing)
      expect(count, lessThan(countAfterCancel + 2));
    });
  });
}
