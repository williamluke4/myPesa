import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/widgets/transactions/transaction_detail_widget.dart';
import 'package:my_pesa/widgets/transactions/transaction_list_widget.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({
    super.key,
    required this.txRef,
  });
  final String txRef;
  @override
  Widget build(BuildContext context) {
    final transactions = context.select<DatabaseCubit, List<Transaction>>(
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
