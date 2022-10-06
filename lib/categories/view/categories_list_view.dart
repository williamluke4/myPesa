import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/pages/category_page.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.categories.length,
          itemBuilder: (BuildContext context, int idx) {
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<Widget>(
                  builder: (context) => CategoryPage(
                    key: key,
                    categoryId: state.categories[idx].id,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  state.categories[idx].name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
