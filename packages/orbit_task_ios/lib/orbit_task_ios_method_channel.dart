import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'orbit_task_ios_platform_interface.dart';

/// An implementation of [OrbitTaskIosPlatform] that uses method channels.
class MethodChannelOrbitTaskIos extends OrbitTaskIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('orbit_task_ios');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
