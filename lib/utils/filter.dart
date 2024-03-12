import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/widgets/advanced_search_form.dart';

List<Transaction> filterTransactions(
  List<Transaction> transactions,
  AdvancedSearchCriteria criteria,
) {
  return transactions.where((Transaction tx) {
    if (!_matchesQuery(tx, criteria.query)) return false;
    if (!_matchesTransactionType(tx, criteria.transactionTypes)) return false;
    if (!_matchesAmount(tx, criteria)) return false;
    if (!_matchesCategory(tx, criteria.categoryIds)) return false;
    return _matchesDateRange(tx, criteria.startDate, criteria.endDate);
  }).toList();
}

bool _matchesQuery(Transaction tx, String? query) {
  if (query == null || query.isEmpty) return true;
  final lowerCaseQuery = query.toLowerCase();
  return tx.recipient.toLowerCase().contains(lowerCaseQuery) ||
      tx.notes.toLowerCase().contains(lowerCaseQuery);
}

bool _matchesTransactionType(Transaction tx, List<TransactionType>? types) {
  return types == null || types.isEmpty || types.contains(tx.type);
}

bool _matchesAmount(Transaction tx, AdvancedSearchCriteria criteria) {
  if (criteria.amountBounds == null || criteria.amountBounds!.isEmpty) {
    return true;
  }
  final amount = tx.getAmount;
  final bounds = criteria.amountBounds!;
  switch (criteria.amountComparison) {
    case AmountComparison.less:
      return amount < bounds.first;
    case AmountComparison.greater:
      return amount > bounds.first;
    case AmountComparison.between:
      return bounds.length >= 2 && amount >= bounds[0] && amount <= bounds[1];
    case AmountComparison.equal:
      return amount == bounds.first;
  }
}

bool _matchesCategory(Transaction tx, List<String>? categoryIds) {
  return categoryIds == null ||
      categoryIds.isEmpty ||
      categoryIds.contains(tx.categoryId);
}

bool _matchesDateRange(Transaction tx, DateTime? startDate, DateTime? endDate) {
  return (startDate == null ||
          (tx.dateTime?.isAfter(startDate.subtract(const Duration(days: 1))) ??
              false)) &&
      (endDate == null ||
          (tx.dateTime?.isBefore(endDate.add(const Duration(days: 1))) ??
              false));
}
