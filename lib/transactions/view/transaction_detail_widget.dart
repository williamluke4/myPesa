import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/categories/view/category_form.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';
import 'package:my_pesa/utils/logger.dart';

class TransactionDetailWidget extends StatelessWidget {
  const TransactionDetailWidget({
    super.key,
    required this.transaction,
  });
  final Transaction transaction;
  Future<void> _handleApplyToAll(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are You Sure?'),
          content: const Text(
            'This will overwrite all transactions with existing categories',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<TransactionsCubit>().applyCategoryToRecipient(
                      transaction.recipient,
                      transaction.categoryId,
                    );
              },
              child: const Text(
                'Only Uncategorized',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<TransactionsCubit>().applyCategoryToRecipient(
                      transaction.recipient,
                      transaction.categoryId,
                      overwrite: true,
                    );
              },
              child: const Text('Yes All'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = context
        .select<CategoriesCubit, List<Category>>((c) => c.state.categories);
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
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
              const SizedBox(height: 10),
              Row(
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
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Category',
                  suffix: IconButton(
                    onPressed: () {
                      final formKey = GlobalKey<FormState>();

                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext c) {
                          return CategoryForm(
                            onSubmitted: () => Navigator.pop(c),
                            formKey: formKey,
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: categories.firstWhere(
                      (element) => element.id == transaction.categoryId,
                      orElse: () => defaultCategory,
                    ),

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
                        context.read<TransactionsCubit>().updateTransaction(
                              transaction.ref,
                              transaction.copyWith(categoryId: category.id),
                            );
                      }
                    },
                  ),
                ),
                // Initial Value
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Notes',
                ),
                initialValue: transaction.notes,
                onFieldSubmitted: (String? value) {
                  if (value != null) {
                    log.d(value);
                    context.read<TransactionsCubit>().updateTransaction(
                          transaction.ref,
                          transaction.copyWith(notes: value),
                        );
                  }
                },
              ),
              TextButton(
                onPressed: () => _handleApplyToAll(context),
                child: const Text('Apply To All'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
