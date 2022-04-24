part of 'transactions_cubit.dart';

class TransactionsState extends Equatable {
  const TransactionsState({
    required this.transactions,
    this.error,
    this.isLoading = false,
  });

  factory TransactionsState.fromJson(Map<String, dynamic> map) {
    final transactions = map['transactions'] is List
        ? List<Map<String, dynamic>>.from(map['transactions'] as List)
        : <Map<String, dynamic>>[];
    return TransactionsState(
      transactions:
          transactions.map<Transaction>(Transaction.fromJson).toList(),
    );
  }

  final List<Transaction> transactions;
  final UserError? error;

  final bool isLoading;

  @override
  List<Object> get props => [transactions, isLoading, error ?? false];

  Map<String, dynamic> toJson(TransactionsState state) {
    final transactions = state.transactions
        .map<Map<String, dynamic>>((x) => x.toJson())
        .toList();
    return <String, dynamic>{
      'transactions': transactions,
    };
  }

  TransactionsState copyWith({
    List<Transaction>? transactions,
    UserError? error,
    bool? isLoading,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
