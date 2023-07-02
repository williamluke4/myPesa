import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as e;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/utils/emoji.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({
    super.key,
    this.category,
    required this.onSubmitted,
  });

  final Category? category;
  final void Function() onSubmitted;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emojiController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _emojiController = TextEditingController(
      text: widget.category?.emoji ?? generateRandomEmoji(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = context
        .select<DatabaseCubit, List<Category>>((c) => c.state.categories);
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) {
                        return e.EmojiPicker(
                          onEmojiSelected: (c, emoji) {
                            setState(() {
                              _emojiController.text = emoji.emoji;
                            });
                            Navigator.pop(context);
                          },
                          config: e.Config(
                            recentTabBehavior: e.RecentTabBehavior.POPULAR,
                            // Issue: https://github.com/flutter/flutter/issues/28894
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                            bgColor: Theme.of(context).colorScheme.background,
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).hoverColor,
                    child: Text(_emojiController.text),
                  ),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                ),
                autofocus: true,
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  final existingName = categories.any(
                    (element) =>
                        element.name == value &&
                        element.id != widget.category?.id,
                  );

                  if (existingName) {
                    return 'This Category name already exists';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      final isValid = formKey.currentState!.validate();
                      if (!isValid) return;
                      if (widget.category != null) {
                        context.read<DatabaseCubit>().updateCategory(
                              widget.category!.id,
                              widget.category!.copyWith(
                                name: _nameController.value.text,
                                emoji: _emojiController.text,
                              ),
                            );
                      } else {
                        context.read<DatabaseCubit>().addCategory(
                              _nameController.value.text,
                              _emojiController.text,
                            );
                      }
                      widget.onSubmitted();
                    },
                    child: Text(widget.category == null ? 'Add' : 'Save'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
