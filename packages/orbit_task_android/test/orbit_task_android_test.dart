import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_task_android/orbit_task_android.dart';
import 'package:orbit_task_android/orbit_task_android_platform_interface.dart';
import 'package:orbit_task_android/orbit_task_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOrbitTaskAndroidPlatform
    with MockPlatformInterfaceMixin
    implements OrbitTaskAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final OrbitTaskAndroidPlatform initialPlatform = OrbitTaskAndroidPlatform.instance;

  test('$MethodChannelOrbitTaskAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOrbitTaskAndroid>());
  });

  test('getPlatformVersion', () async {
    OrbitTaskAndroid orbitTaskAndroidPlugin = OrbitTaskAndroid();
    MockOrbitTaskAndroidPlatform fakePlatform = MockOrbitTaskAndroidPlatform();
    OrbitTaskAndroidPlatform.instance = fakePlatform;

    expect(await orbitTaskAndroidPlugin.getPlatformVersion(), '42');
  });
}
