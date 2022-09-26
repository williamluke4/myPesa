import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/transaction.dart';

DateFormat dateFormat = DateFormat('dd-MM-yyyy');

class TransactionRowWidget extends StatelessWidget {
  const TransactionRowWidget({
    required Key key,
    required this.transaction,
    required this.onTap,
    this.selected = false,
  }) : super(key: key);
  final bool selected;
  final Transaction transaction;
  final void Function(Transaction transaction)? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap!(transaction) : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Text(
                transaction.recipient,
                style: const TextStyle(fontWeight: FontWeight.w100),
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
