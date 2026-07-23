// Basic smoke test for the RCDA Instructor App.
//
// This checks that the app boots to the splash screen, and that tapping
// "Get Started" takes you into the instructor dashboard.

import 'package:flutter_test/flutter_test.dart';

import 'package:rcda_instructor_app/main.dart';

void main() {
  testWidgets('Splash screen shows and leads into the dashboard',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RCDAInstructorApp());

    // Verify the splash/opening screen appears first.
    expect(find.text('RC Driving Academy'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap "Get Started" and trigger a frame.
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Verify we've landed on the instructor dashboard.
    expect(find.text('My Dashboard'), findsOneWidget);
    expect(find.text('Get Started'), findsNothing);
  });
}
