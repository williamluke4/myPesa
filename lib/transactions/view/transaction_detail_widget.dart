import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/categories/view/category_form.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';

class TransactionDetailWidget extends StatelessWidget {
  const TransactionDetailWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);
  final Transaction transaction;
  @override
  Widget build(BuildContext context) {
    final categories = context
        .select<CategoriesCubit, List<Category>>((c) => c.state.categories);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Category'),
                  Row(
                    children: [
                      DropdownButton(
                        // Initial Value
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
                            context.read<TransactionsCubit>().updateTrasaction(
                                  transaction.ref,
                                  transaction.copyWith(categoryId: category.id),
                                );
                          }
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          final _formKey = GlobalKey<FormState>();

                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext c) {
                              return CategoryForm(
                                formKey: _formKey,
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  )
                ],
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
