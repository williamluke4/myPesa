import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/pages/transaction_page.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';
import 'package:my_pesa/transactions/view/transaction_list_widget.dart';
import 'package:my_pesa/utils/logger.dart';

class CategoryDetailsView extends StatelessWidget {
  const CategoryDetailsView({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    final transactions = context.select<TransactionsCubit, List<Transaction>>(
      (settingsCubit) => settingsCubit.state.transactions,
    );
    final filteredTransactions =
        transactions.where((element) => element.categoryId == category.id);

    final totalIn = filteredTransactions.fold<double>(0, (value, tx) {
      if (tx.type == TransactionType.IN) {
        final amount = double.tryParse(tx.amount.replaceAll(',', ''));
        if (amount == null) {
          log.e('Failed to Convert ${tx.amount} to double');
          return value;
        }

        return value + amount;
      }
      return value;
    });
    final totalOut = filteredTransactions.fold<double>(0, (value, tx) {
      if (tx.type == TransactionType.OUT) {
        final amount = double.tryParse(tx.amount.replaceAll(',', ''));
        if (amount == null) {
          log.e('Failed to Convert ${tx.amount} to double');
          return value;
        }

        return value + amount;
      }
      return value;
    });
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text('In: $totalIn'), Text('Out: $totalOut')],
          ),
        ),
        Expanded(
          child: TransactionListWidget(
            onTransactionTap: (tx) {
              Navigator.push(
                context,
                MaterialPageRoute<Widget>(
                  builder: (context) => TransactionPage(
                    key: key,
                    txRef: tx.ref,
                  ),
                ),
              );
            },
            showCategories: false,
            transactions: filteredTransactions.toList(),
          ),
        ),
      ],
    );
  }
}
