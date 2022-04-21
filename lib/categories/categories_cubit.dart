import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/utils/logger.dart';

part 'categories_state.dart';

class CategoriesCubit extends HydratedCubit<CategoriesState> {
  CategoriesCubit() : super(const CategoriesInitial());

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

  Future<void> addCategory(String name) async {
    log.d('Adding category $name');
    final categories = [...state.categories, Category(name: name)];
    log.d(categories);
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
