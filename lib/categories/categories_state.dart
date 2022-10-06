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
          categories: defaultCategories,
          defaultCategory: defaultCategory,
        );
}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded({
    required super.categories,
    required super.defaultCategory,
    super.error,
  });
}
