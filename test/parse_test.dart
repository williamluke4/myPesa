// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/utils/parse.dart';

var messages = <String>[
  """QC352PDIVL Confirmed. Ksh1,000.00 sent to SOPHIA  MWENI 0702972812 on 3/3/22 at 5:28 PM. New M-PESA balance is Ksh25,203.19. Transaction cost, Ksh12.00. Amount you can transact within the day is 292,600.00. Send KES100 & below to POCHI LA BIASHARA for FREE! To reverse, foward this message to 456.""",
];

void main() {
  test('Test Regex', () {
    // Build our app and trigger a frame.
    // Verify that our counter has incremented.
    for (var message in messages) {
      var transaction = getMpesaTransaction(message);
      expect(transaction.amount, equals("1,000.00"));
      expect(transaction.balance, equals("25,203.19"));
      expect(transaction.recipient, "SOPHIA  MWENI 0702972812");
      expect(transaction.dateTime, DateTime(2022, 3, 3, 17, 28));
    }
  });
}
