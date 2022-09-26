import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/utils/logger.dart';

part 'categories_state.dart';

class CategoriesCubit extends HydratedCubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  @override
  void onError(Object error, StackTrace stackTrace) {
    log.e('Error: $error', [stackTrace]);
    super.onError(error, stackTrace);
  }

  @override
  void onChange(Change<CategoriesState> change) {
    log
      ..d('Current: ${change.currentState}')
      ..d('Next: ${change.nextState}');
    super.onChange(change);
  }

  Future<void> editCategory(String name, Category category) async {
    final idx = state.categories.indexWhere((c) => c.id == category.id);
    if (idx != -1) {
      final updatedCategories = List<Category>.from(state.categories);
      updatedCategories[idx] = updatedCategories[idx].copyWith(name: name);
      emit(
        CategoriesLoaded(
          categories: updatedCategories,
          defaultCategory: state.defaultCategory,
        ),
      );
    } else {
      emit(
        CategoriesLoaded(
          categories: state.categories,
          defaultCategory: state.defaultCategory,
          error: const UserError(message: 'Unable to Update Transaction'),
        ),
      );
    }
  }

  Future<Category?> addCategory(String name) async {
    log.d('Adding category $name');
    if (name.isEmpty || state.categories.any((c) => c.name == name)) {
      return null;
    }
    final category = Category(name: name.trim());
    final categories = [...state.categories, category];
    emit(
      CategoriesLoaded(
        categories: categories,
        defaultCategory: state.defaultCategory,
      ),
    );
    return category;
  }

  Category? findCategory(String id) {
    log.d('Finding category $id');
    if (id.isEmpty) {
      return null;
    }
    return state.categories.firstWhere((c) => c.id == id);
  }

  Future<void> deleteCategory(Category category) async {
    if (category.id == Category.none().id ||
        defaultCategories.contains(category)) {
      emit(
        CategoriesLoaded(
          categories: state.categories,
          defaultCategory: state.defaultCategory,
          error: notAllowedToDeleteError,
        ),
      );
      return;
    }
    final idx = state.categories.indexWhere((c) => c.id == category.id);

    final categories = [...state.categories]..removeAt(idx);
    emit(
      CategoriesLoaded(
        categories: categories,
        defaultCategory: state.defaultCategory,
      ),
    );
  }

  @override
  CategoriesState? fromJson(Map<String, dynamic> json) {
    final categories = json['categories'] is List<dynamic>
        ? List<Map<String, dynamic>>.from(json['categories'] as List)
            .map<Category>(Category.fromJson)
            .toList()
        : <Category>[];

    final defaultCategory =
        Category.fromJson(json['defaultCategory'] as Map<String, dynamic>);
    return CategoriesLoaded(
      categories: categories,
      defaultCategory: defaultCategory,
    );
  }

  @override
  Map<String, dynamic>? toJson(CategoriesState state) {
    return <String, dynamic>{
      'categories': state.categories.map((e) => e.toJson()).toList(),
      'defaultCategory': state.defaultCategory.toJson(),
    };
  }
}
