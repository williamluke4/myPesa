import 'dart:async';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/utils/parse.dart';

Future<List<Transaction>> getTransactionsFromMessages(String sender) async {
  final query = SmsQuery();
  final transactions = <Transaction>[];
  final messages = await query.querySms(
    address: sender,
    sort: true,
    kinds: [SmsQueryKind.inbox],
  );
  for (final message in messages) {
    final transaction = parseTransaction(message);
    if (transaction != null) {
      transactions.add(transaction);
    }
  }
  sortTransactions(transactions);
  return transactions;
}

void sortTransactions(List<Transaction> transactions) {
  transactions.sort((a, b) {
    if (b.dateTime != null && a.dateTime != null) {
      return b.dateTime!.compareTo(a.dateTime!);
    } else {
      return 0;
    }
  });
}
