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
}
