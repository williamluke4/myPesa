import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/widgets/grid_delegate.dart';

class CategoriesGridPage extends CategoriesGridView {
  const CategoriesGridPage({required super.onCategoryTap, super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select A Category'),
      ),
      body: CategoriesGridView(onCategoryTap: onCategoryTap),
    );
  }
}

class CategoriesGridView extends StatelessWidget {
  const CategoriesGridView({required this.onCategoryTap, super.key});
  final void Function(Category) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseCubit, DatabaseState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCountAndMainAxisExtent(
                  crossAxisCount: context.layout.value(
                    xs: 1,
                    sm: 2,
                    md: 3,
                    lg: 4,
                    xl: 5,
                  ),
                  mainAxisExtent: 60,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: state.categories.length,
                itemBuilder: (BuildContext context, int idx) {
                  return CategoryGridItem(
                    onTap: onCategoryTap,
                    category: state.categories[idx],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.onTap,
    required this.category,
  });
  final Category category;
  final void Function(Category) onTap;

  Widget buildItem(BuildContext context) {
    final emojiStyle = Theme.of(context).textTheme.titleLarge;
    final textStyle = Theme.of(context).textTheme.titleMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: 50,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).hoverColor,
              child: Text(category.emoji, style: emojiStyle),
            ),
          ),
        ),
        Expanded(child: Text(category.name, style: textStyle)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(category),
      child: Card(
        child: Center(
          child: buildItem(context),
        ),
      ),
    );
  }
}
