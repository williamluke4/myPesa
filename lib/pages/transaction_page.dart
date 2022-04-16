import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/settings/settings_cubit.dart';
import 'package:my_pesa/widgets/transaction_detail_widget.dart';
import 'package:my_pesa/widgets/transaction_list_widget.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({
    Key? key,
    required this.transaction,
  }) : super(key: key);
  final Transaction transaction;
  @override
  Widget build(BuildContext context) {
    final transactions = context
        .read<SettingsCubit>()
        .state
        .transactions
        ?.where((tx) => transaction.recipient == tx.recipient)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: Column(
        children: <Widget>[
          TransactionDetailWidget(transaction: transaction),
          const Text('All Transactions'),
          Expanded(
            child: TransactionListWidget(
              transactions: transactions ?? [],
              disabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
