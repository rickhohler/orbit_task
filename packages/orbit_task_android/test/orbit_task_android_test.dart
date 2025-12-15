import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_task_android/orbit_task_android.dart';
import 'package:orbit_task_platform_interface/orbit_task_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late OrbitTaskAndroid platform;
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    platform = OrbitTaskAndroid();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('orbit_task'), (
          MethodCall methodCall,
        ) async {
          log.add(methodCall);
          return null;
        });
    log.clear();
  });

  test('cancelTask sends correct method call', () async {
    await platform.cancelTask('task_123');
    expect(log, hasLength(1));
    expect(log.first.method, 'cancelTask');
    expect(log.first.arguments, {'taskId': 'task_123'});
  });

  test('cancelAllTasks sends correct method call', () async {
    await platform.cancelAllTasks();
    expect(log, hasLength(1));
    expect(log.first.method, 'cancelAllTasks');
  });

  test('scheduleOneTimeTask sends correct method call', () async {
    final task = BackgroundTask(
      id: "1",
      taskName: "test_task",
      inputData: {"foo": "bar"},
    );
    await platform.scheduleOneTimeTask(task);

    expect(log, hasLength(1));
    expect(log.first.method, 'scheduleOneTimeTask');
    expect(log.first.arguments['taskName'], 'test_task');
    expect(log.first.arguments['inputData'], {'foo': 'bar'});
  });

  test('scheduleRecurringTask sends correct method call', () async {
    final task = BackgroundTask(
      id: "2",
      taskName: "recurring_task",
      frequency: Duration(minutes: 30),
    );
    await platform.scheduleRecurringTask(task);

    expect(log, hasLength(1));
    expect(log.first.method, 'scheduleRecurringTask');
    expect(log.first.arguments['frequency'], 30);
  });
}
