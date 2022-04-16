import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/pages/transaction_page.dart';

DateFormat dateFormat = DateFormat('dd-MM-yyyy');

class TransactionRowWidget extends StatelessWidget {
  const TransactionRowWidget({
    Key? key,
    required this.transaction,
    required this.disabled,
  }) : super(key: key);
  final Transaction transaction;
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled
          ? () {}
          : () {
              Navigator.push(
                context,
                MaterialPageRoute<Widget>(
                  builder: (context) => TransactionPage(
                    transaction: transaction,
                  ),
                ),
              );
            },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
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
            Expanded(
              flex: 2,
              child: Text(
                transaction.balance,
                textAlign: TextAlign.right,
              ),
            )
          ],
        ),
      ),
    );
  }
}
