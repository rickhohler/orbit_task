
import 'orbit_task_ios_platform_interface.dart';

class OrbitTaskIos {
  Future<String?> getPlatformVersion() {
    return OrbitTaskIosPlatform.instance.getPlatformVersion();
  }
}
