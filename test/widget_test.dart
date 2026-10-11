import 'package:flutter_test/flutter_test.dart';
import 'package:harvesthub/main.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const HarvestHubApp());
    expect(find.text('HarvestHub'), findsWidgets);
  });
}