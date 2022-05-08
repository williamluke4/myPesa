import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/categories/view/categories_pie_view.dart';
import 'package:my_pesa/categories/view/category_form.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.categories.length,
          itemBuilder: (BuildContext context, int idx) {
            final categoryCubit = context.read<CategoriesCubit>();
            return SwipeActionCell(
              key: ValueKey(state.categories[idx]),
              trailingActions: <SwipeAction>[
                SwipeAction(
                  ///
                  ///This attr should be passed to first action
                  ///
                  icon: const Icon(Icons.delete),
                  nestedAction: SwipeNestedAction(title: 'Are you Sure?'),
                  onTap: (CompletionHandler handler) async {
                    await handler(true);
                    await categoryCubit.deleteCategory(idx);
                  },
                  color: Colors.redAccent,
                ),
                SwipeAction(
                  icon: const Icon(Icons.edit),
                  onTap: (CompletionHandler handler) async {
                    ///false means that you just do nothing,it will close
                    /// action buttons by default
                    handler(false);
                    final _formKey = GlobalKey<FormState>();
                    await showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext c) {
                        return CategoryForm(
                          formKey: _formKey,
                          category: state.categories[idx],
                        );
                      },
                    );
                  },
                  color: Colors.green,
                ),
              ],
              child: InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext c) {
                      return const CategoriesPieChart();
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    state.categories[idx].name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}