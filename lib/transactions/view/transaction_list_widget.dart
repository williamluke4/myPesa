import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/pages/category_page.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';
import 'package:my_pesa/transactions/view/transaction_row_widget.dart';

class TransactionListWidget extends StatefulWidget {
  const TransactionListWidget({
    super.key,
    required this.transactions,
    required this.onTransactionTap,
    this.showCategories = true,
  });
  final List<Transaction> transactions;
  final bool showCategories;

  final void Function(Transaction transaction)? onTransactionTap;

  @override
  State<TransactionListWidget> createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  List<String> selectedRefs = [];
  @override
  Widget build(BuildContext context) {
    final groupedByDate =
        groupBy<Transaction, String>(widget.transactions, (obj) => obj.date);
    final categories = context.select<CategoriesCubit, List<Category>>(
      (c) => c.state.categories,
    );
    final categoriesMap = {for (var e in categories) e.id: e};

    final dates = groupedByDate.keys.toList();
    final datesMap = groupedByDate.map((String date, List<Transaction> txs) {
      return MapEntry(
        date,
        groupBy<Transaction, String>(txs, (tx) => tx.categoryId),
      );
    });
    return Column(
      children: [
        if (selectedRefs.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${selectedRefs.length} Selected'),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        await showDialog<void>(
                          context: context,
                          builder: (ctx) {
                            return Dialog(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: defaultCategory,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items

                                  items: categories.map((c) {
                                    return DropdownMenuItem(
                                      value: c,
                                      child: Text(c.name),
                                    );
                                  }).toList(),
                                  onChanged: (Category? category) {
                                    if (category != null) {
                                      context
                                          .read<TransactionsCubit>()
                                          .changeCategory(
                                            toCategoryId: category.id,
                                            txRefs: selectedRefs,
                                          );
                                    }
                                    Navigator.pop(ctx);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                        setState(() {
                          selectedRefs = [];
                        });
                      },
                      child: const Text('Move'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedRefs = widget.transactions
                              .map<String>((e) => e.ref)
                              .toList();
                        });
                      },
                      child: const Text('Select All'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedRefs = [];
                        });
                      },
                      child: const Text('Deselect All'),
                    )
                  ],
                ),
              ],
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                context.read<TransactionsCubit>().refreshTransactions(),
            child: ListView.builder(
              itemCount: datesMap.length,
              key: const PageStorageKey<String>('transactions_list_controller'),
              restorationId: 'transactions_list',
              itemBuilder: (context, index) {
                final date = dates[index];
                final categoriesOnDateMap = datesMap[date];
                final categoryKeys = categoriesOnDateMap?.keys ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        textAlign: TextAlign.center,
                        date,
                      ),
                    ),
                    ...categoryKeys.map<Column>((key) {
                      final transactions = categoriesOnDateMap?[key] ?? [];
                      return Column(
                        children: [
                          if (widget.showCategories)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<Widget>(
                                    builder: (context) => CategoryPage(
                                      categoryId: categoriesMap[key]!.id,
                                    ),
                                  ),
                                ),
                                child: Chip(
                                  label: Text(
                                    categoriesMap[key]?.name ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ...transactions.map<TransactionRowWidget>(
                            (tx) => TransactionRowWidget(
                              key: Key(tx.ref),
                              transaction: tx,
                              selected: selectedRefs.contains(tx.ref),
                              onTap: selectedRefs.isEmpty
                                  ? widget.onTransactionTap
                                  : (transaction) {
                                      if (selectedRefs
                                          .contains(transaction.ref)) {
                                        setState(
                                          () => selectedRefs
                                              .remove(transaction.ref),
                                        );
                                      } else {
                                        setState(
                                          () =>
                                              selectedRefs.add(transaction.ref),
                                        );
                                      }
                                    },
                              onLongPress: (tx) {
                                if (selectedRefs.isEmpty) {
                                  setState(() {
                                    selectedRefs.add(tx.ref);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    })
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
