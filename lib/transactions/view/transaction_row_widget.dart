import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/transaction.dart';

DateFormat dateFormat = DateFormat('dd-MM-yyyy');

class TransactionRowWidget extends StatelessWidget {
  const TransactionRowWidget({
    required Key key,
    required this.transaction,
    required this.onTap,
    this.onLongPress,
    this.selected = false,
  }) : super(key: key);
  final bool selected;
  final Transaction transaction;
  final void Function(Transaction transaction)? onTap;
  final void Function(Transaction transaction)? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected ? Theme.of(context).highlightColor : null,
      child: InkWell(
        splashColor: Theme.of(context).highlightColor,
        onTap: onTap != null ? () => onTap!(transaction) : null,
        onLongPress:
            onLongPress != null ? () => onLongPress!(transaction) : null,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  transaction.recipient,
                  style: selected
                      ? const TextStyle(fontWeight: FontWeight.w300)
                      : const TextStyle(fontWeight: FontWeight.w100),
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
      ),
    );
  }
}
