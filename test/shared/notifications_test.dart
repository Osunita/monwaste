import 'package:flutter_test/flutter_test.dart';
import 'package:monwaste/shared/notifications.dart';

void main() {
  group('NotificationService', () {
    test('cancelAll does not throw when not initialized', () async {
      // Should not throw even if init() was never called.
      await expectLater(
        NotificationService.cancelAll(),
        completes,
      );
    });

    test('init is safe to call multiple times', () async {
      await NotificationService.init();
      await NotificationService.init(); // second call is a no-op
      // If we reach here without exception, the test passes.
      expect(true, isTrue);
    });
  });
}
