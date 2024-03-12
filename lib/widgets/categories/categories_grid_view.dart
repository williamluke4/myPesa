import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/widgets/grid_delegate.dart';

class CategoriesGridPage extends CategoriesGridView {
  const CategoriesGridPage({
    required super.onCategoryTap,
    super.predictedCategories,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select A Category'),
      ),
      body: CategoriesGridView(
        onCategoryTap: onCategoryTap,
        predictedCategories: predictedCategories,
      ),
    );
  }
}

class CategoriesGridView extends StatelessWidget {
  const CategoriesGridView({
    required this.onCategoryTap,
    super.key,
    this.predictedCategories,
  });

  final void Function(Category) onCategoryTap;
  final List<(String, double)>? predictedCategories;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseCubit, DatabaseState>(
      builder: (context, state) {
        // Logic to merge and highlight predicted categories
        final predictionsMap =
            predictedCategories?.asMap().map((_, e) => MapEntry(e.$1, e.$2));
        final categories = state.categories;
        if (predictedCategories != null) {
          categories.sort((a, b) {
            // Sort by predicted score
            // If no prediction, default to -100
            // then sort by category name
            if (predictionsMap == null ||
                predictionsMap[a.id] == null && predictionsMap[b.id] == null) {
              return a.name.compareTo(b.name);
            }
            final aScore = predictionsMap[a.id] ?? -100;
            final bScore = predictionsMap[b.id] ?? -100;
            return bScore.compareTo(aScore);
          });
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCountAndMainAxisExtent(
                  crossAxisCount:
                      context.layout.value(xs: 1, sm: 2, md: 3, lg: 4, xl: 5),
                  mainAxisExtent: 60,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: state.categories.length,
                itemBuilder: (BuildContext context, int idx) {
                  final category = state.categories[idx];
                  final isPredicted =
                      predictionsMap?.containsKey(category.id) ?? false;
                  return CategoryGridItem(
                    onTap: onCategoryTap,
                    category: category,
                    isSuggested: isPredicted,
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
    this.isSuggested = false,
  });

  final Category category;
  final void Function(Category) onTap;
  final bool isSuggested;

  @override
  Widget build(BuildContext context) {
    // Adjust style or add icons if `isSuggested` is true
    final icon = isSuggested
        ? Icon(Icons.lightbulb_outline, color: Colors.yellow[700])
        : null;

    return InkWell(
      onTap: () => onTap(category),
      child: Card(
        child: Center(
          child: ListTile(
            trailing: icon,
            title: buildItem(context),
          ),
        ),
      ),
    );
  }

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
}
