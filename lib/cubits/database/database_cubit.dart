import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/data/transactions_repository.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/utils/file.dart';
import 'package:my_pesa/utils/logger.dart';

part 'database_state.dart';

class DatabaseCubit extends HydratedCubit<DatabaseState> {
  DatabaseCubit({required this.transactionsRepository})
      : super(DatabaseState.initial());

  final TransactionsRepository transactionsRepository;

  Future<void> updateTransaction(String ref, Transaction tx) async {
    final txIdx = state.transactions.indexWhere((tx) => tx.ref == ref);
    if (txIdx != -1) {
      final updatedTransactions = List<Transaction>.from(state.transactions);
      updatedTransactions[txIdx] = tx;
      log.d('Updated transaction: $tx');
      emit(state.copyWith(transactions: updatedTransactions));
    } else {
      emit(
        state.copyWith(
          error: const UserError(message: 'Unable to Update Transaction'),
        ),
      );
    }
  }

  Future<void> reset() async {
    emit(DatabaseState.initial());
  }

  Future<void> applyCategoryToRecipient(
    String recipient,
    String categoryId, {
    bool overwrite = false,
  }) async {
    log.d('Applying $categoryId to transactions from $recipient');

    final updatedTransactions =
        List<Transaction>.from(state.transactions).map((e) {
      if (e.recipient == recipient &&
          (overwrite || e.categoryId == Category.none().id)) {
        return e.copyWith(categoryId: categoryId);
      }
      return e;
    }).toList();
    emit(state.copyWith(transactions: updatedTransactions));
  }

  Future<void> changeCategory({
    String? fromCategoryId,
    String? toCategoryId,
    List<String>? txRefs,
  }) async {
    final changeTo = toCategoryId ?? Category.none().id;
    log.d('Changing to $changeTo');
    var updatedTransactions = List<Transaction>.from(state.transactions);
    if (txRefs == null || txRefs.isEmpty && fromCategoryId != null) {
      // Apply to all
      updatedTransactions = updatedTransactions.map((e) {
        if (e.categoryId != fromCategoryId) return e;
        return e.copyWith(categoryId: changeTo);
      }).toList();
    } else {
      // Only apply to transactions contained in list
      updatedTransactions = updatedTransactions.map((e) {
        if ((fromCategoryId != null && e.categoryId != fromCategoryId) ||
            !txRefs.contains(e.ref)) {
          return e;
        }
        return e.copyWith(categoryId: changeTo);
      }).toList();
    }

    emit(state.copyWith(transactions: updatedTransactions));
  }

  Future<void> fetchTransactionsFromSMS() async {
    final txsFromSms = await transactionsRepository.getTxsFromSMS();
    for (final currentTx in state.transactions) {
      // The Reason why it is done this way round is to allow for changes
      // in the sms parsing logic
      final idx =
          txsFromSms.indexWhere((txFromSMS) => txFromSMS.ref == currentTx.ref);
      if (idx != -1) {
        txsFromSms[idx] = txsFromSms[idx].merge(currentTx);
      }
      if (idx == -1) {
        // TX Does Not exist in sms messages
        txsFromSms.add(currentTx);
      }
    }
    emit(
      state.copyWith(
        transactions: txsFromSms,
      ),
    );
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    log.e('Error: $error', [stackTrace]);
    super.onError(error, stackTrace);
  }

  @override
  Map<String, dynamic>? toJson(DatabaseState state) {
    final transactions = state.transactions.map((x) => x.toJson()).toList();
    final categories = state.categories.map((e) => e.toJson()).toList();
    final defaultCategory = state.defaultCategory.toJson();
    return <String, dynamic>{
      'transactions': transactions,
      'categories': categories,
      'defaultCategory': defaultCategory
    };
  }

  Future<void> updateCategory(String id, Category category) async {
    final idx = state.categories.indexWhere((c) => c.id == id);
    if (idx != -1) {
      final updatedCategories = List<Category>.from(state.categories);
      updatedCategories[idx] = category;
      emit(
        state.copyWith(
          categories: updatedCategories,
          defaultCategory: state.defaultCategory,
        ),
      );
    } else {
      emit(
        state.copyWith(
          error: const UserError(message: 'Unable to Update Category'),
        ),
      );
    }
  }

  Future<Category?> addCategory(String name, String emoji) async {
    log.d('Adding category $name');
    if (name.isEmpty || state.categories.any((c) => c.name == name)) {
      return null;
    }
    final category = Category(name: name.trim(), emoji: emoji);
    final categories = [...state.categories, category]
      ..sort((a, b) => a.name.compareTo(b.name));
    emit(
      state.copyWith(
        categories: categories,
      ),
    );
    return category;
  }

  Category? findCategory(String id) {
    log.d('Finding category $id');
    if (id.isEmpty) {
      return null;
    }
    return state.categories
        .firstWhere((c) => c.id == id, orElse: Category.none);
  }

  Future<void> deleteCategory(Category category) async {
    if (category.id == Category.none().id ||
        defaultCategories.contains(category)) {
      emit(
        state.copyWith(
          error: notAllowedToDeleteError,
        ),
      );
      return;
    }
    await changeCategory(fromCategoryId: category.id);
    final idx = state.categories.indexWhere((c) => c.id == category.id);
    final categories = [...state.categories]..removeAt(idx);
    emit(
      state.copyWith(
        categories: categories,
      ),
    );
  }

  Future<void> import() async {
    final file = await selectFile();

    if (file != null) {
      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final t = data['transactions'] as List<dynamic>;
      final c = data['categories'] as List<dynamic>;
      final importedTransactions = t
          .map((dynamic e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList();
      final importedCategories = c
          .map((dynamic e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
      final newCategories = <Category>[...state.categories];
      for (final importedCategory in importedCategories) {
        final idx = newCategories
            .indexWhere((element) => element.id == importedCategory.id);
        if (idx == -1) {
          newCategories.add(importedCategory);
        } else if (importedCategory.lastModified >
            newCategories[idx].lastModified) {
          newCategories[idx] = importedCategory;
        }
      }
      newCategories.sort((a, b) => a.name.compareTo(b.name));

      final newTransactions = <Transaction>[...state.transactions];
      for (final c in importedTransactions) {
        final idx =
            newTransactions.indexWhere((element) => element.ref == c.ref);
        if (idx == -1) newTransactions.add(c);
        if (idx != -1) {
          newTransactions[idx] = newTransactions[idx].merge(c);
        }
      }
      emit(
        state.copyWith(
          transactions: newTransactions,
          categories: newCategories,
        ),
      );
    }
  }

  Future<void> backup() async {
    emit(state.copyWith(isLoading: true));

    final data = jsonEncode(
      {
        'transactions': state.transactions,
        'categories': state.categories,
        'version': 1
      },
    );
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(now);
    final fileName = 'mypesa-backup-$formattedDate.json';
    final filePath = await saveToFile(fileName, data);

    if (filePath == null) {
      emit(
        state.copyWith(
          isLoading: false,
          error: const UserError(message: 'Oops something went wrong'),
        ),
      );
    } else {
      emit(
        state.copyWith(isLoading: false),
      );
    }

    // url_launcher -> file:<path>
  }

  @override
  DatabaseState? fromJson(Map<String, dynamic> json) {
    final categories = json['categories'] is List<dynamic>
        ? List<Map<String, dynamic>>.from(json['categories'] as List)
            .map<Category>(Category.fromJson)
            .toList()
        : <Category>[]
      ..sort((a, b) => a.name.compareTo(b.name));

    final defaultCategory =
        Category.fromJson(json['defaultCategory'] as Map<String, dynamic>);
    final transactions = json['transactions'] is List
        ? List<Map<String, dynamic>>.from(json['transactions'] as List)
        : <Map<String, dynamic>>[];
    return DatabaseState(
      categories: categories,
      defaultCategory: defaultCategory,
      transactions:
          transactions.map(Transaction.fromJson).toList(growable: false),
    );
  }
}
