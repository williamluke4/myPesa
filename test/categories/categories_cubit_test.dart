import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/errors.dart';

import '../helpers/hydrated_bloc.dart';

void main() {
  group('CategoriesCubit', () {
    late CategoriesCubit categoriesCubit1;
    late CategoriesCubit categoriesCubit2;

    setUp(() async {
      categoriesCubit1 = await mockHydratedStorage(
        CategoriesCubit.new,
      );
      categoriesCubit2 = await mockHydratedStorage(
        CategoriesCubit.new,
      );
    });
    test('equality', () async {
      expect(
        categoriesCubit1.state,
        categoriesCubit2.state,
      );
    });
    test('hydration', () async {
      final c1 = await categoriesCubit1.addCategory('Test');
      final c2 = await categoriesCubit1.addCategory('Test 🤔');

      expect(
        categoriesCubit1.state,
        CategoriesLoaded(
          categories: [...defaultCategories, c1!, c2!],
          defaultCategory: defaultCategory,
        ),
      );
      final json = categoriesCubit1.toJson(categoriesCubit1.state);
      final state = categoriesCubit2.fromJson(json!);
      expect(
        state,
        categoriesCubit1.state,
      );
    });
    test('unable to delete default', () async {
      await categoriesCubit1.deleteCategory(Category.none());
      expect(
        categoriesCubit1.state,
        CategoriesLoaded(
          error: notAllowedToDeleteError,
          categories: categoriesCubit1.state.categories,
          defaultCategory: defaultCategory,
        ),
      );
    });
    group('operations', () {
      test('crud', () async {
        // Add
        final c1 = await categoriesCubit1.addCategory('Test');
        final c2 = await categoriesCubit1.addCategory('Test 🤔');
        expect(
          categoriesCubit1.state,
          CategoriesLoaded(
            categories: [...defaultCategories, c1!, c2!],
            defaultCategory: defaultCategory,
          ),
        );

        // Delete
        await categoriesCubit1.deleteCategory(c1);
        expect(
          categoriesCubit1.state,
          CategoriesLoaded(
            categories: [...defaultCategories,c2],
            defaultCategory: defaultCategory,
          ),
        );
        // Update
        await categoriesCubit1.editCategory('Test 🤔🤔', c2);
        expect(
          categoriesCubit1.findCategory(c2.id)?.name,
          'Test 🤔🤔',
        );

        final json = categoriesCubit1.toJson(categoriesCubit1.state);
        final state = categoriesCubit2.fromJson(json!);
        expect(
          state,
          categoriesCubit1.state,
        );
      });
    });
  });
}
