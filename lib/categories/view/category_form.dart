import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/data/models/category.dart';

class CategoryForm extends StatelessWidget {
  const CategoryForm({
    Key? key,
    this.category,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final Category? category;

  @override
  Widget build(BuildContext context) {
    final _categoryNameController = TextEditingController(text: category?.name);
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
                controller: _categoryNameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                ),
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (category != null) {
                        context.read<CategoriesCubit>().editCategory(
                              category!.name,
                              Category(name: _categoryNameController.text),
                            );
                      } else {
                        context.read<CategoriesCubit>().addCategory(
                              _categoryNameController.text,
                            );
                      }
                    }
                  },
                  child: Text(category == null ? 'Add' : 'Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
