import 'package:flutter/material.dart';
import 'package:my_pesa/categories/view/categories_list_view.dart';
import 'package:my_pesa/categories/view/category_form.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Column(
        children: const [
          Expanded(child: CategoriesListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
