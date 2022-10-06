import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';
import 'package:my_pesa/transactions/view/transaction_detail_widget.dart';
import 'package:my_pesa/transactions/view/transaction_list_widget.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({
    super.key,
    required this.txRef,
  });
  final String txRef;
  @override
  Widget build(BuildContext context) {
    final transactions = context.select<TransactionsCubit, List<Transaction>>(
      (c) => c.state.transactions,
    );

    final transaction =
        transactions.firstWhere((element) => element.ref == txRef);

    final filteredTransactions = transactions
        .where((tx) => transaction.recipient == tx.recipient)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TransactionDetailWidget(transaction: transaction),
          const Text('All Transactions'),
          Expanded(
            child: TransactionListWidget(
              transactions: filteredTransactions,
              onTransactionTap: (tx) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<Widget>(
                    builder: (context) => TransactionPage(
                      key: key,
                      txRef: tx.ref,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
