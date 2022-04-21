import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/settings/settings_cubit.dart';

class TransactionDetailWidget extends StatelessWidget {
  const TransactionDetailWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);
  final Transaction transaction;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesCubit, CategoriesState>(
      listener: (context, state) {
        // TODO: implement listener
        print(state);
      },
      buildWhen: (previous, current) {
        print(previous);
        print(current);
        return true;
      },
      builder: (context, state) {
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                            value: transaction.category,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items

                            items: state.categories
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (Category? newValue) {
                              if (newValue != null) {
                                context
                                    .read<SettingsCubit>()
                                    .updateTrasactionCategory(
                                      transaction.ref,
                                      newValue,
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
                                    final _categoryNameController =
                                        TextEditingController();

                                    return Form(
                                      key: _formKey,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller:
                                                    _categoryNameController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Category Name',
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter a name';
                                                  }
                                                  final existingName =
                                                      state.categories.any(
                                                    (element) =>
                                                        element.name == value,
                                                  );

                                                  if (existingName) {
                                                    return 'This Category name already exists';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // Validate returns true if the form is valid, or false otherwise.
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      // If the form is valid, display a snackbar. In the real world,
                                                      // you'd often call a server or save the information in a database.
                                                      context
                                                          .read<
                                                              CategoriesCubit>()
                                                          .addCategory(
                                                            _categoryNameController
                                                                .text,
                                                          );
                                                    }
                                                  },
                                                  child: const Text('Add'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            icon: Icon(Icons.add),
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
      },
    );
  }
}
