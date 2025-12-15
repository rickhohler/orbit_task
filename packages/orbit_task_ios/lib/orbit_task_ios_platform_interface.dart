import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'orbit_task_ios_method_channel.dart';

abstract class OrbitTaskIosPlatform extends PlatformInterface {
  /// Constructs a OrbitTaskIosPlatform.
  OrbitTaskIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static OrbitTaskIosPlatform _instance = MethodChannelOrbitTaskIos();

  /// The default instance of [OrbitTaskIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelOrbitTaskIos].
  static OrbitTaskIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OrbitTaskIosPlatform] when
  /// they register themselves.
  static set instance(OrbitTaskIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
