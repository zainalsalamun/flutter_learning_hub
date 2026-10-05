import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_hub/main.dart';

void main() {
  testWidgets('FlutterLearningHubApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlutterLearningHubApp());

    // Verify that the bottom navigation labels exist
    expect(find.text('Fundamentals'), findsOneWidget);
    expect(find.text('Basic Widgets'), findsOneWidget);
    expect(find.text('Pro Catalog'), findsOneWidget);
  });
}
