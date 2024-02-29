import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/utils/logger.dart';
import 'package:my_pesa/widgets/categories/categories_grid_view.dart';
import 'package:my_pesa/widgets/categories/category_form.dart';

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
                context.read<DatabaseCubit>().applyCategoryToRecipient(
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
                context.read<DatabaseCubit>().applyCategoryToRecipient(
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
        .select<DatabaseCubit, List<Category>>((c) => c.state.categories);
    final category = categories.firstWhere(
      (element) => element.id == transaction.categoryId,
      orElse: () => defaultCategory,
    );
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
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: SelectableText(transaction.account),
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
                  border: InputBorder.none,
                  labelText: 'Category',
                  suffix: IconButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext c) {
                          return CategoryForm(
                            onSubmitted: () => Navigator.pop(c),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
                child: CategoryGridItem(
                  category: category,
                  onTap: (_) async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (context) => CategoriesGridPage(
                          onCategoryTap: (selectedCategory) {
                            context.read<DatabaseCubit>().updateTransaction(
                                  transaction.ref,
                                  transaction.copyWith(
                                    categoryId: selectedCategory.id,
                                  ),
                                );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
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
                    context.read<DatabaseCubit>().updateTransaction(
                          transaction.ref,
                          transaction.copyWith(notes: value),
                        );
                  }
                },
              ),
              TextButton(
                onPressed: () => _handleApplyToAll(context),
                child: const Text('Apply To All'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
