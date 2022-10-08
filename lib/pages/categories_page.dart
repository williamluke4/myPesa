import 'package:flutter/material.dart';
import 'package:my_pesa/widgets/categories/categories_list_view.dart';
import 'package:my_pesa/widgets/categories/category_form.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: const CategoriesListView(),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
