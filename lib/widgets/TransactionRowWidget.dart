import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myPesa/models/Account.dart';
import 'package:myPesa/models/Transaction.dart';
import 'package:myPesa/pages/TransactionPage.dart';

DateFormat dateFormat = DateFormat("dd-MM-yyyy");

class TransactionRowWidget extends StatelessWidget {
  final Transaction transaction;
  final Account account;
  final bool disabled;
  Widget build(BuildContext context) {
    return InkWell(
        onTap: this.disabled ? (){} : () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TransactionPage(this.account, this.transaction)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
          child: Row(
              children: <Widget>[
                      Expanded(
                          flex: 6,
                          child: Text(
                                this.transaction.recipient != null
                                    ? this.transaction.recipient
                                    : '-',
                          ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(
                            this.transaction.amount != null
                                ? this.transaction.amount
                                : "-",
                            style: TextStyle(
                                color:
                                    this.transaction.type != TransactionType.IN
                                        ? Colors.red
                                        : Colors.green),
                            textAlign: TextAlign.right,
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(
                            this.transaction.balance != null
                                ? this.transaction.balance
                                : "-",
                            textAlign: TextAlign.right,
                          ))
                    ]
          ),
        ));
  }

  TransactionRowWidget(this.account, this.transaction, this.disabled);
}
