import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/pages/transaction_page.dart';

DateFormat dateFormat = DateFormat('dd-MM-yyyy');

class TransactionRowWidget extends StatelessWidget {
  const TransactionRowWidget({
    required Key key,
    required this.transaction,
    required this.replace,
  }) : super(key: key);
  final Transaction transaction;
  final bool replace;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: replace
          ? () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<Widget>(
                  builder: (context) => TransactionPage(
                    key: key,
                    txRef: transaction.ref,
                  ),
                ),
              );
            }
          : () {
              Navigator.push(
                context,
                MaterialPageRoute<Widget>(
                  builder: (context) => TransactionPage(
                    key: key,
                    txRef: transaction.ref,
                  ),
                ),
              );
            },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Text(
                transaction.recipient,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                transaction.amount,
                style: TextStyle(
                  color: transaction.type != TransactionType.IN
                      ? Colors.red
                      : Colors.green,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
