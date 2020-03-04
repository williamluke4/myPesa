import 'package:flutter/material.dart';
import 'package:myPesa/models/Account.dart';
import 'package:myPesa/models/Transaction.dart';
import 'package:myPesa/widgets/TransactionDetailWidget.dart';
import 'package:myPesa/widgets/TransactionListWidget.dart';


class TransactionPage extends StatelessWidget {
  final Transaction transaction;
  final Account account;
  @override
  Widget build(BuildContext context) {
    var transactions = this.account.transactions.where( (tx) => this.transaction.recipient == tx.recipient).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text("Transactions"),
        ),
        body: Column(
          children: <Widget>[
            TransactionDetailWidget(this.account, this.transaction),
            Text("Transactions"),
            Expanded(
              child:TransactionListWidget(this.account, transactions)
            ),
          ],
        )
    );
  }
  TransactionPage(this.account, this.transaction);
}
