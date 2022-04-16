import 'package:flutter/material.dart';
import 'package:my_pesa/data/models/transaction.dart';

class TransactionDetailWidget extends StatelessWidget {
  const TransactionDetailWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(transaction.date),
                    Row(
                      children: <Widget>[
                        const Text('Ref: '),
                        SelectableText(
                          transaction.ref,
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                    Expanded(
                      child: SelectableText(transaction.recipient),
                    ),
                    SelectableText(
                      transaction.amount,
                      style: TextStyle(
                        color: transaction.type != TransactionType.IN
                            ? Colors.red
                            : Colors.green,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
