import 'package:flutter/material.dart';
import 'package:my_pesa/categories/view/categories_list_view.dart';
import 'package:my_pesa/categories/view/categories_pie_view.dart';
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
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(8),
            child: const CategoriesPieChart(),
          ),
          const Expanded(child: CategoriesListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final _formKey = GlobalKey<FormState>();
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext c) {
              return CategoryForm(
                onSubmitted: () => Navigator.pop(c),
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
