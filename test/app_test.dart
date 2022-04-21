import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/app.dart';

import './helpers/hydrated_bloc.dart';

void main() {
  group('App', () {
    testWidgets('renders Home', (tester) async {
      await mockHydratedStorage(() => tester.pumpWidget(App()));
      expect(find.byType(Home), findsOneWidget);
    });
  });
}
