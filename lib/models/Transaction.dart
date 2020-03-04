import 'package:myPesa/utils/parse.dart';

enum TransactionType { IN, OUT }

class Transaction   {
  String amount;
  String ref;
  String txCost;
  String recipient;
  DateTime dateTime;
  String date;
  String balance;
  String body;
  TransactionType type;

  Transaction(recipient, ref, amount, txCost, balance, type, dateTime, body){
    this.recipient = recipient;
    this.ref = ref;
    this.amount = amount;
    this.txCost = txCost;
    this.balance = balance;
    this.type = type;
    this.dateTime = dateTime;
    this.body = body;
    this.date = this.dateTime != null ? dateTimeToDate(this.dateTime) : '';
  }
}
