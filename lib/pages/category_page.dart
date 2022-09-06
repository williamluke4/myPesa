import 'package:flutter/material.dart';
import 'package:my_pesa/categories/view/category_detail_view.dart';
import 'package:my_pesa/data/models/category.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: CategoryDetailsView(category: category),
    );
  }
}
