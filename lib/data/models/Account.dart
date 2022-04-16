import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:my_pesa/data/models/Transaction.dart';

// TODO Fix this
@immutable
class Account extends Equatable {
  Account(this.name, this.balance, this.transactions);
  List<Transaction> transactions = <Transaction>[];
  String name;
  String balance;

  void sortTransactions() {
    transactions.sort((a, b) {
      if (b.dateTime != null && a.dateTime != null) {
        return b.dateTime!.compareTo(a.dateTime!);
      } else {
        return 0;
      }
    });
    balance = transactions[0].balance;
  }

  @override
  List<Object?> get props => [name, balance, ...transactions];
}
