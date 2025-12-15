import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_task_web/orbit_task_web.dart';
import 'package:orbit_task_web/orbit_task_web_platform_interface.dart';
import 'package:orbit_task_web/orbit_task_web_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOrbitTaskWebPlatform
    with MockPlatformInterfaceMixin
    implements OrbitTaskWebPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final OrbitTaskWebPlatform initialPlatform = OrbitTaskWebPlatform.instance;

  test('$MethodChannelOrbitTaskWeb is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOrbitTaskWeb>());
  });

  test('getPlatformVersion', () async {
    OrbitTaskWeb orbitTaskWebPlugin = OrbitTaskWeb();
    MockOrbitTaskWebPlatform fakePlatform = MockOrbitTaskWebPlatform();
    OrbitTaskWebPlatform.instance = fakePlatform;

    expect(await orbitTaskWebPlugin.getPlatformVersion(), '42');
  });
}
