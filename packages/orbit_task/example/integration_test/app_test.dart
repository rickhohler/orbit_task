import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:orbit_task_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('OrbitTask Example App Tests', () {
    testWidgets('Schedule Simple Task verifies UI update', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find the "One-Time (Simple)" button
      final simpleTaskBtn = find.textContaining('One-Time\n(Simple)');
      expect(simpleTaskBtn, findsOneWidget);

      // Tap to schedule
      await tester.tap(simpleTaskBtn);
      await tester.pumpAndSettle();

      // Verify log appears. We look for the "Scheduling Simple One-Time Task..." text
      final schedulingLog = find.textContaining('Scheduling Simple One-Time Task...');
      expect(schedulingLog, findsOneWidget);
    });

    testWidgets('Cancel Task verifies UI update', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find "Cancel Last" button
      final cancelLastBtn = find.textContaining('Cancel Last');
      expect(cancelLastBtn, findsOneWidget);

      // Tap cancel
      await tester.tap(cancelLastBtn);
      await tester.pumpAndSettle();

      // Verify cancellation log or logic
      // We check for either "Cancelling Task ID" OR "No last task ID" to be robust.
      final successFinder = find.textContaining('Cancelling Task ID');
      final failFinder = find.textContaining('No last task ID');
      
      final foundSuccess = successFinder.evaluate().isNotEmpty;
      final foundFail = failFinder.evaluate().isNotEmpty;
      
      expect(foundSuccess || foundFail, isTrue, reason: 'Should log either cancellation success or missing ID warning');
    });
  });
}
