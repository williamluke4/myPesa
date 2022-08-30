import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/utils/parse/mpesa.dart';

import '../helpers/mocks.dart';

void main() {
  group('parseMpesaTransaction', () {
    test('sentTransaction', () {
      final transaction = parseMpesaTransaction(sentTransaction.body)!;
      expect(transaction.amount, equals(sentTransaction.amount));
      expect(transaction.balance, equals(sentTransaction.balance));
      expect(transaction.txCost, equals(sentTransaction.txCost));
      expect(transaction.type, equals(sentTransaction.type));

      expect(transaction.recipient, sentTransaction.recipient);
      expect(transaction.dateTime, sentTransaction.dateTime);
    });
    test('sentTransaction with wrongTimeFormat', () {
      final transaction =
          parseMpesaTransaction(sentTransactionWrongTimeFormat.body)!;
      expect(transaction.amount, equals(sentTransactionWrongTimeFormat.amount));
      expect(
        transaction.balance,
        equals(sentTransactionWrongTimeFormat.balance),
      );
      expect(transaction.txCost, equals(sentTransactionWrongTimeFormat.txCost));
      expect(transaction.type, equals(sentTransactionWrongTimeFormat.type));

      expect(transaction.recipient, sentTransactionWrongTimeFormat.recipient);
      expect(transaction.dateTime, sentTransactionWrongTimeFormat.dateTime);
    });
    test('depositTransaction', () {
      final transaction = parseMpesaTransaction(depositTransaction.body)!;
      expect(transaction.amount, equals(depositTransaction.amount));
      expect(transaction.balance, equals(depositTransaction.balance));
      expect(transaction.txCost, equals(depositTransaction.txCost));
      expect(transaction.type, equals(depositTransaction.type));

      expect(transaction.recipient, depositTransaction.recipient);
      expect(transaction.dateTime, depositTransaction.dateTime);
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
