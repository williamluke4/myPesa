import 'package:flutter/material.dart';
import 'package:myPesa/models/Account.dart';
import 'package:myPesa/models/Transaction.dart';
import 'package:myPesa/widgets/TransactionRowWidget.dart';
import "package:collection/collection.dart";

class TransactionListWidget  extends StatelessWidget {
  final List<Transaction> transactions;
  final Account account;
  final bool disabled;
  Widget build(BuildContext context){
    var groupedByDate = groupBy(this.transactions, (obj) => obj.date);
    var dates = groupedByDate.keys.toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: dates.length,
        itemBuilder: (context, index) {
          var transactions = groupedByDate[dates[index]];
          Transaction tx = this.transactions[index];
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dates[index]!= null
                  ? dates[index]
                      : '-',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...transactions.map((tx) => TransactionRowWidget(this.account, tx, this.disabled))

              ]
          );
        },
      ),
    );
  }
  TransactionListWidget(this.account, this.transactions, this.disabled);
}
