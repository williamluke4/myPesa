import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/data/transactions_repository.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/utils/logger.dart';
import 'package:permission_handler/permission_handler.dart';

part 'transactions_state.dart';

class TransactionsCubit extends HydratedCubit<TransactionsState> {
  TransactionsCubit() : super(const TransactionsState(transactions: []));
  final TransactionsRepository _transactionsRepository =
      TransactionsRepository();

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

  Future<void> refreshTransactions() async {
    if (await Permission.sms.isGranted == false) {
      await Permission.sms.request();
    }
    // Loading of messages
    final transactions =
        await _transactionsRepository.getTransactionsFromMessages();
    // TODO(x): This is not efficient
    for (final tx in state.transactions) {
      if (tx.categoryId != Category.none().id) {
        final idx = transactions.indexWhere((element) => element.ref == tx.ref);
        if (idx != -1) {
          transactions[idx] =
              transactions[idx].copyWith(categoryId: tx.categoryId);
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
