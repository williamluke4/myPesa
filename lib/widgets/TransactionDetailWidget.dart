import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myPesa/models/Account.dart';
import 'package:myPesa/models/Transaction.dart';

class TransactionDetailWidget extends StatelessWidget {
  final Transaction transaction;
  final Account account;

  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(this.transaction.date),
                Row(
                  children: <Widget>[
                    Text('Ref: '),
                    SelectableText(
                      this.transaction.ref != null
                          ? this.transaction.ref
                          : '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )
                ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: SelectableText(this.transaction.recipient)),
                    SelectableText(
                      this.transaction.amount != null
                          ? this.transaction.amount
                          : "-",
                      style: TextStyle(
                          color:
                          this.transaction.type != TransactionType.IN
                              ? Colors.red
                              : Colors.green),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  TransactionDetailWidget(this.account, this.transaction);
}
