// Basic test for Avida-Droid app

import 'package:flutter_test/flutter_test.dart';
import 'package:avida_droid/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AvidaDroidApp());

    // Wait for all animations and async operations to complete
    await tester.pumpAndSettle();

    // Verify that the app bar contains the title
    expect(find.text('Avida-Droid'), findsOneWidget);
  });
}
