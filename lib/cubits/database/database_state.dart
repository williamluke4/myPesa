part of 'database_cubit.dart';

class DatabaseState extends Equatable {
  const DatabaseState({
    required this.transactions,
    required this.categories,
    required this.defaultCategory,
    this.error,
    this.isLoading,
  });

  factory DatabaseState.initial() {
    return DatabaseState(
      categories: defaultCategories,
      defaultCategory: Category.none(),
      transactions: const [],
    );
  }

  final UserError? error;
  final bool? isLoading;
  final List<Category> categories;
  final Category defaultCategory;
  final List<Transaction> transactions;

  @override
  List<Object> get props => [defaultCategory, categories, transactions];

  DatabaseState copyWith({
    List<Transaction>? transactions,
    List<Category>? categories,
    Category? defaultCategory,
    UserError? error,
    bool? isLoading,
  }) {
    return DatabaseState(
      transactions: transactions ?? this.transactions,
      defaultCategory: defaultCategory ?? this.defaultCategory,
      error: error ?? this.error,
      categories: categories ?? this.categories,
      isLoading: isLoading,
    );
  }
}
