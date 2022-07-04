import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/data/models/category.dart';

class CategoryForm extends StatelessWidget {
  const CategoryForm({
    Key? key,
    this.category,
    required this.onSubmitted,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final Category? category;
  final void Function() onSubmitted;
  @override
  Widget build(BuildContext context) {
    final categories = context
        .select<CategoriesCubit, List<Category>>((c) => c.state.categories);
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                ),
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  final existingName = categories.any(
                    (element) => element.name == value,
                  );

                  if (existingName) {
                    return 'This Category name already exists';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  final isValid = formKey.currentState!.validate();
                  if (!isValid) {
                    return;
                  }
                  if (category != null) {
                    context.read<CategoriesCubit>().editCategory(
                          category!.name,
                          Category(name: value),
                        );
                  } else {
                    context.read<CategoriesCubit>().addCategory(
                          value,
                        );
                  }
                  onSubmitted();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
