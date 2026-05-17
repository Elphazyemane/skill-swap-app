import 'package:flutter_test/flutter_test.dart';
import 'package:skill_swap_app/main.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillSwapApp());
  });
}