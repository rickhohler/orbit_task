import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_task_web/orbit_task_web.dart';
import 'package:orbit_task_platform_interface/orbit_task_platform_interface.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late OrbitTaskWebWeb platform;

  setUp(() {
    platform = OrbitTaskWebWeb();
  });

  test('scheduleOneTimeTask executes task after delay', () {
    fakeAsync((async) {
      bool taskExecuted = false;
      
      platform.initialize((taskName, args) {
         if (taskName == "test_web_task") {
           taskExecuted = true;
         }
      });

      platform.scheduleOneTimeTask(BackgroundTask(
        id: "web_1",
        taskName: "test_web_task",
      ));

      expect(taskExecuted, isFalse);
      async.elapse(const Duration(milliseconds: 100)); // wait for internal timer
      expect(taskExecuted, isTrue);
    });
  });

  test('scheduleRecurringTask executes periodically', () {
    fakeAsync((async) {
      int executionCount = 0;
      
      platform.initialize((taskName, args) {
         if (taskName == "recurring_web") {
           executionCount++;
         }
      });

      platform.scheduleRecurringTask(BackgroundTask(
        id: "web_rec",
        taskName: "recurring_web",
        frequency: Duration(minutes: 10),
      ));

      expect(executionCount, 0);
      async.elapse(const Duration(minutes: 10)); // 1st run
      expect(executionCount, 1);
      async.elapse(const Duration(minutes: 10)); // 2nd run
      expect(executionCount, 2);
      
      platform.cancelTask("web_rec");
      async.elapse(const Duration(minutes: 10)); // cancelled
      expect(executionCount, 2);
    });
  });
}
