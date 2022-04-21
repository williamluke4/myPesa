part of 'categories_cubit.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState({
    required this.categories,
    required this.defaultCategory,
  });
  final List<Category> categories;
  final Category defaultCategory;
  @override
  List<Object> get props => [categories, defaultCategory];
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial()
      : super(
          categories: const [unCategorized],
          defaultCategory: unCategorized,
        );
}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded({
    required List<Category> categories,
    required Category defaultCategory,
  }) : super(categories: categories, defaultCategory: defaultCategory);
}
