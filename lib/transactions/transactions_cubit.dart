import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/data/transactions_repository.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/utils/logger.dart';
import 'package:permission_handler/permission_handler.dart';

part 'transactions_state.dart';

class TransactionsCubit extends HydratedCubit<TransactionsState> {
  TransactionsCubit({required this.transactionsRepository})
      : super(const TransactionsState(transactions: []));
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

  Future<void> import(List<Transaction> transactions) async {
    final newTransactions = <Transaction>[...state.transactions];
    for (final c in transactions) {
      final idx =
          state.transactions.indexWhere((element) => element.ref == c.ref);
      if (idx == -1) newTransactions.add(c);
    }
    emit(state.copyWith(
      transactions: newTransactions,
    ));
  }

  Future<void> reset() async {
    emit(const TransactionsState(transactions: []));
  }

  Future<void> applyCategoryToRecipient(
    String recipient,
    String categoryId,
  ) async {
    log.d('Applying $categoryId to all transactions from $recipient');

    final updatedTransactions =
        List<Transaction>.from(state.transactions).map((e) {
      if (e.recipient == recipient) {
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
    log.d('Changing to ${toCategoryId ?? Category.none().id}');
    var updatedTransactions = List<Transaction>.from(state.transactions);
    if (txRefs == null || txRefs.isEmpty && fromCategoryId != null) {
      // Apply to all
      updatedTransactions = updatedTransactions.map((e) {
        if (e.categoryId != fromCategoryId) return e;
        return e.copyWith(categoryId: toCategoryId ?? Category.none().id);
      }).toList();
    } else {
      // Only apply to transactions contained in list
      updatedTransactions = updatedTransactions.map((e) {
        if ((fromCategoryId != null && e.categoryId != fromCategoryId) ||
            !txRefs.contains(e.ref)) {
          return e;
        }
        return e.copyWith(categoryId: toCategoryId ?? Category.none().id);
      }).toList();
    }

    emit(state.copyWith(transactions: updatedTransactions));
  }

  Future<void> refreshTransactions({
    @visibleForTesting bool test = false,
  }) async {
    if (!test && await Permission.sms.isGranted == false) {
      await Permission.sms.request();
    }
    // Loading of messages
    final transactions =
        await transactionsRepository.getTransactionsFromMessages();
    // TODO(x): This is not efficient
    for (final tx in state.transactions) {
      if (tx.categoryId != Category.none().id || tx.notes.isNotEmpty) {
        final idx = transactions.indexWhere((element) => element.ref == tx.ref);
        if (idx != -1) {
          transactions[idx] = transactions[idx]
              .copyWith(categoryId: tx.categoryId, notes: tx.notes);
        }
      }
    }
    emit(
      state.copyWith(
        transactions: transactions,
      ),
    );
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    log.e('Error: $error', [stackTrace]);
    super.onError(error, stackTrace);
  }

  @override
  TransactionsState? fromJson(Map<String, dynamic> json) {
    final transactions = json['transactions'] is List
        ? List<Map<String, dynamic>>.from(json['transactions'] as List)
        : <Map<String, dynamic>>[];
    return TransactionsState(
      transactions:
          transactions.map(Transaction.fromJson).toList(growable: false),
    );
  }

  @override
  Map<String, dynamic>? toJson(TransactionsState state) {
    final transactions = state.transactions
        .map<Map<String, dynamic>>((x) => x.toJson())
        .toList();
    return <String, dynamic>{
      'transactions': transactions,
    };
  }
}
