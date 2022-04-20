// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/utils/parse.dart';

String sentTransaction =
    '''QC352PDIVL Confirmed. Ksh1,000.00 sent to SOPHIA  MWENI 0702972812 on 3/3/22 at 5:28 PM. New M-PESA balance is Ksh25,203.19. Transaction cost, Ksh12.00. Amount you can transact within the day is 292,600.00. Send KES100 & below to POCHI LA BIASHARA for FREE! To reverse, foward this message to 456.''';
String sentTransactionWrongTimeFormat =
    '''PAG5ONUZYT Confirmed. Ksh1,600.00 sent to 0780603578 on 16/1/21 at 5:9 PM. New M-PESA balance is Ksh226.85. Transaction cost, Ksh74.00. To reverse, forward this message to 456.''';
String reversedTransaction =
    '''OAV2QRV4K4  Confirmed. Transaction OAO4LC1T3S has been reversed.  Your account balance is now Ksh12,260.03.''';


String depositTransaction =
'''PK95FQHDN1 Confirmed. On 9/11/21 at 7:07 PM Give Ksh60,000.00 cash to Naivas Supermarket Kilifi New M-PESA balance is Ksh104,061.96. You can now access M-PESA via *334#''';

void main() {
  group('parseMpesaTransaction', () {
    test('sentTransaction', () {
      final transaction = parseMpesaTransaction(sentTransaction)!;
      expect(transaction.amount, equals('1,000.00'));
      expect(transaction.balance, equals('25,203.19'));
      expect(transaction.txCost, equals('12.00'));
      expect(transaction.type, equals(TransactionType.OUT));

      expect(transaction.recipient, 'SOPHIA  MWENI 0702972812');
      expect(transaction.dateTime, DateTime(2022, 3, 3, 17, 28));
    });
    test('sentTransaction with wrongTimeFormat', () {
      final transaction =
          parseMpesaTransaction(sentTransactionWrongTimeFormat)!;
      expect(transaction.amount, equals('1,600.00'));
      expect(transaction.balance, equals('226.85'));
      expect(transaction.txCost, equals('74.00'));
      expect(transaction.type, equals(TransactionType.OUT));

      expect(transaction.recipient, '0780603578');
      expect(transaction.dateTime, DateTime(2021, 1, 16, 17, 9));
    });
    test('depositTransaction', () {
      final transaction =
          parseMpesaTransaction(depositTransaction) as Transaction;
      expect(transaction.amount, equals('60,000.00'));
      expect(transaction.balance, equals('104,061.96'));
      expect(transaction.type, equals(TransactionType.IN));

      expect(transaction.recipient, 'Naivas Supermarket Kilifi');
      expect(transaction.dateTime, DateTime(2021, 11, 9, 19, 7));
    });

    // TODO(williamluke4): Add support for reversed transactions.
    // test('reversedTransaction', () {
    //   final transaction = parseMpesaTransaction(reversedTransaction);
    //   expect(transaction.amount, equals('1,000.00'));
    //   expect(transaction.balance, equals('25,203.19'));
    //   expect(transaction.txCost, equals('12.00'));
    //   expect(transaction.type, equals(TransactionType.OUT));

    //   expect(transaction.recipient, 'SOPHIA  MWENI 0702972812');
    //   expect(transaction.dateTime, DateTime(2022, 3, 3, 17, 28));
    // });
  });
}
