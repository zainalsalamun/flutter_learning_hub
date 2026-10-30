import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/main.dart';

void main() {
  testWidgets('FlutterLearningHubApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlutterLearningHubApp());

    // Verify that the bottom navigation labels exist according to design
    expect(find.text('Belajar'), findsOneWidget);
    expect(find.text('Jalur Karir'), findsOneWidget);
    expect(find.text('Kuis'), findsAtLeastNWidgets(1));
    expect(find.text('Diskusi'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets('FundamentalsHomePage does not overflow on narrow mobile screens (360x640)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FlutterLearningHubApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('FundamentalsHomePage does not overflow on ultra-compact screens (320x568)',
      (WidgetTester tester) async {
    final List<FlutterErrorDetails> errors = [];
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      errors.add(details);
      oldOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = oldOnError);

    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FlutterLearningHubApp());
    await tester.pumpAndSettle();

    expect(errors, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
