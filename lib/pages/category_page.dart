import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/categories/view/category_detail_view.dart';
import 'package:my_pesa/categories/view/category_form.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';
import 'package:my_pesa/widgets/are_you_sure_dialog.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final category = context
        .select<CategoriesCubit, Category>((c) => c.findCategory(categoryId)!);
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () async {
              final _formKey = GlobalKey<FormState>();
              await showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext c) {
                  return CategoryForm(
                    onSubmitted: () => Navigator.pop(c),
                    formKey: _formKey,
                    category: category,
                  );
                },
              );
            },
          ),
          PopupMenuButton<PopupMenuItem>(
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: const Text('Delete'),
                  onTap: () async {
                    //https://stackoverflow.com/questions/69568862/flutter-showdialog-is-not-shown-on-popupmenuitem-tap
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AreYouSureDialog(
                            onYes: () {
                              context
                                  .read<TransactionsCubit>()
                                  .changeCategory(fromCategoryId: category.id);
                              context
                                  .read<CategoriesCubit>()
                                  .deleteCategory(category);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    });
                  })
            ],
          )
        ],
      ),
      body: CategoryDetailsView(category: category),
    );
  }
}
