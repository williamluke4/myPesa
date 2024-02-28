import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/widgets/are_you_sure_dialog.dart';
import 'package:my_pesa/widgets/categories/category_detail_view.dart';
import 'package:my_pesa/widgets/categories/category_form.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final category = context
        .select<DatabaseCubit, Category>((c) => c.findCategory(categoryId)!);
    return Scaffold(
      appBar: AppBar(
        title: Text('${category.emoji} ${category.name}'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () async {
              await showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext c) {
                  return CategoryForm(
                    onSubmitted: () => Navigator.pop(c),
                    category: category,
                  );
                },
              );
            },
          ),
          PopupMenuButton<PopupMenuItem<void>>(
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
                                .read<DatabaseCubit>()
                                .deleteCategory(category);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: CategoryDetailsView(category: category),
    );
  }
}
