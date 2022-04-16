import 'package:my_pesa/utils/parse.dart';

// ignore: constant_identifier_names
enum TransactionType { IN, OUT, UNKNOWN }

class Transaction {
  Transaction({
    this.recipient = '',
    this.ref = '',
    this.amount = '',
    this.txCost = '',
    this.balance = '',
    this.type = TransactionType.UNKNOWN,
    this.body = '',
    this.dateTime,
  }) : date = dateTime != null ? dateTimeToString(dateTime) : '';

  final String amount;
  final String ref;
  final String txCost;
  final String recipient;
  final String date;
  final String balance;
  final String body;
  final DateTime? dateTime;
  final TransactionType type;
}
