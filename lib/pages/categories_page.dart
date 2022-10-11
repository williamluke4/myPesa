import 'package:flutter/material.dart';
import 'package:my_pesa/pages/category_page.dart';
import 'package:my_pesa/widgets/categories/categories_grid_view.dart';
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
      body: CategoriesGridView(
        onCategoryTap: (category) => Navigator.push(
          context,
          MaterialPageRoute<Widget>(
            builder: (context) => CategoryPage(
              key: key,
              categoryId: category.id,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
