import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_task_ios/orbit_task_ios.dart';
import 'package:orbit_task_ios/orbit_task_ios_platform_interface.dart';
import 'package:orbit_task_ios/orbit_task_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOrbitTaskIosPlatform
    with MockPlatformInterfaceMixin
    implements OrbitTaskIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final OrbitTaskIosPlatform initialPlatform = OrbitTaskIosPlatform.instance;

  test('$MethodChannelOrbitTaskIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOrbitTaskIos>());
  });

  test('getPlatformVersion', () async {
    OrbitTaskIos orbitTaskIosPlugin = OrbitTaskIos();
    MockOrbitTaskIosPlatform fakePlatform = MockOrbitTaskIosPlatform();
    OrbitTaskIosPlatform.instance = fakePlatform;

    expect(await orbitTaskIosPlugin.getPlatformVersion(), '42');
  });
}
