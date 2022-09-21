part of 'categories_cubit.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState({
    required this.categories,
    required this.defaultCategory,
    this.error,
  });
  final UserError? error;
  final List<Category> categories;
  final Category defaultCategory;
  @override
  List<Object> get props => [categories, defaultCategory];
}

class CategoriesInitial extends CategoriesState {
  CategoriesInitial()
      : super(
          categories: [],
          defaultCategory: defaultCategory,
        );
}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded({
    required List<Category> categories,
    required Category defaultCategory,
    UserError? error,
  }) : super(
          categories: categories,
          defaultCategory: defaultCategory,
          error: error,
        );
}
