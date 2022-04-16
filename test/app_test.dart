import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/app.dart';

void main() {
  group('App', () {
    testWidgets('renders Home', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(Home), findsOneWidget);
    });
  });
}
