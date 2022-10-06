import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/transaction.dart';

int stringToInt(String value) {
  final strVal = value.replaceAll(',', '');
  return int.tryParse(strVal.split('.')[0]) ?? 0;
}

class Total {
  Total();
  int incoming = 0;
  int outgoing = 0;
  void add(Transaction tx) {
    if (tx.type == TransactionType.IN) {
      incoming += stringToInt(tx.amount);
    }
    if (tx.type == TransactionType.OUT) {
      outgoing += stringToInt(tx.amount);
    }
  }
}

class CategoryInsight {
  CategoryInsight({required this.txs, required this.categoryId})
      : total = Total();
  final String categoryId;
  List<Transaction> txs;
  final Total total;
}

class Insight {
  Insight({required this.name, required this.txs}) {
    for (final tx in txs) {
      total.add(tx);
      final idx = categories.indexWhere((e) => e.categoryId == tx.categoryId);
      if (idx != -1) {
        categories[idx]!.total.add(tx);
      } else {
        final i = CategoryInsight(txs: [tx], categoryId: tx.categoryId);
        i.txs.add(tx);
        i.total.add(tx);
        categories.add(i);
      }
    }
  }
  final String name;
  final List<Transaction> txs;
  final Total total = Total();
  final categories = <CategoryInsight>[];
}

List<Insight> buildInsights(List<Transaction> txs) {
  final months = groupTransactionsByMonth(txs);
  final insights = <Insight>[];
  for (final month in months.keys) {
    final txsInMonth = months[month];
    final insight = Insight(name: month, txs: txsInMonth ?? []);
    insights.add(insight);
  }
  return insights;
}

Map<String, List<Transaction>> groupTransactionsByMonth(
  List<Transaction> txs,
) {
  // final now = DateTime.now();
  // final from = DateTime(now.year, now.month - 3);
  final formatter = DateFormat('MMM y');

  return groupBy<Transaction, String>(
    txs,
    (obj) => obj.dateTime != null ? formatter.format(obj.dateTime!) : 'Unknown',
  );
}
