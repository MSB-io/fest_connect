import 'package:flutter_test/flutter_test.dart';
import 'package:fest_connect/main.dart';

void main() {
  testWidgets('FestConnect smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FestConnectApp());
    await tester.pumpAndSettle();

    // Verify app bar title exists
    expect(find.text('FestConnect'), findsOneWidget);
    // Verify College Fest header exists
    expect(find.text('College Fest 2026'), findsOneWidget);
  });
}
