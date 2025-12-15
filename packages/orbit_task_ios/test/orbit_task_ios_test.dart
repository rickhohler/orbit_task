import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_task_ios/orbit_task_ios.dart';
import 'package:orbit_task_platform_interface/orbit_task_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late OrbitTaskIos platform;
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    platform = OrbitTaskIos();
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
    await platform.cancelTask('task_ios_1');
    expect(log, hasLength(1));
    expect(log.first.method, 'cancelTask');
    expect(log.first.arguments, {'taskId': 'task_ios_1'});
  });

  test('scheduleOneTimeTask sends correct method call', () async {
    final task = BackgroundTask(
      id: "1",
      taskName: "ios_task",
      inputData: {"a": 1},
    );
    await platform.scheduleOneTimeTask(task);

    expect(log, hasLength(1));
    expect(log.first.method, 'scheduleOneTimeTask');
    expect(log.first.arguments['taskName'], 'ios_task');
  });
}
