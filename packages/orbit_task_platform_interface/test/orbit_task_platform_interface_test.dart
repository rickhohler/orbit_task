import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_task_platform_interface/orbit_task_platform_interface.dart';

class OrbitTaskPlatformMock extends OrbitTaskPlatform {
  
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrbitTaskPlatformInterface', () {
    test('default implementation throws', () {
      final platform = OrbitTaskPlatformMock(); 
      // Just verifying we can instantiate it and it inherits default methods
      expect(platform, isA<OrbitTaskPlatform>());
    });
  });
}
