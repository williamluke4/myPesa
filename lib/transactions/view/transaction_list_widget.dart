import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';
import 'package:my_pesa/transactions/view/transaction_row_widget.dart';

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({
    Key? key,
    required this.transactions,
    required this.onTransactionTap,
  }) : super(key: key);
  final List<Transaction> transactions;

  final void Function(Transaction transaction)? onTransactionTap;
  @override
  Widget build(BuildContext context) {
    final groupedByDate =
        groupBy<Transaction, String>(transactions, (obj) => obj.date);
    final categories = context.select<CategoriesCubit, List<Category>>(
      (c) => c.state.categories,
    );
    final categoriesMap = {for (var e in categories) e.id: e};

    final dates = groupedByDate.keys.toList();
    final datesMap = groupedByDate.map((String key, List<Transaction> value) {
      return MapEntry(
        key,
        groupBy<Transaction, String>(value, (obj) => obj.categoryId),
      );
    });
    return Padding(
      padding: const EdgeInsets.all(8),
      child: RefreshIndicator(
        onRefresh: () =>
            context.read<TransactionsCubit>().refreshTransactions(),
        child: ListView.builder(
          itemCount: datesMap.length,
          key: const PageStorageKey<String>('transactions_list_controller'),
          restorationId: 'transactions_list',
          itemBuilder: (context, index) {
            final date = dates[index];
            final categories = datesMap[date];
            final categoryKeys = categories?.keys ?? [];
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    textAlign: TextAlign.center,
                    date,
                  ),
                  ...categoryKeys.map<Column>((key) {
                    final transactions = categories?[key] ?? [];
                    return Column(
                      children: [
                        Chip(
                          label: Text(
                            categoriesMap[key]?.name ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...transactions.map<TransactionRowWidget>(
                          (tx) => TransactionRowWidget(
                            key: Key(tx.ref),
                            transaction: tx,
                            onTap: onTransactionTap,
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
