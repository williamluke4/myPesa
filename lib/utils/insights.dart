import 'package:collection/collection.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/utils/datetime.dart';

int stringToInt(String value) {
  final strVal = value.replaceAll(',', '');
  return int.tryParse(strVal.split('.')[0]) ?? 0;
}

class Total {
  Total();
  int incoming = 0;
  int outgoing = 0;
  int get diff => incoming - outgoing;
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
  CategoryInsight({required this.categoryId}) : total = Total();
  final String categoryId;
  List<Transaction> txs = [];
  final Total total;
  void add(Transaction tx) {
    txs.add(tx);
    total.add(tx);
  }
}

class Insight {
  Insight({required this.name, required this.datetime, required this.txs}) {
    for (final tx in txs) {
      total.add(tx);
      final idx = categories.indexWhere((e) => e.categoryId == tx.categoryId);
      if (idx != -1) {
        categories[idx].total.add(tx);
      } else {
        categories.add(CategoryInsight(categoryId: tx.categoryId)..add(tx));
      }
    }
  }
  final String name;
  final DateTime datetime;
  final List<Transaction> txs;
  final Total total = Total();
  final categories = <CategoryInsight>[];
}

List<Insight> buildMonthlyInsights(Iterable<Transaction> txs) {
  final months = groupTransactionsByMonth(txs);
  final insights = <Insight>[];
  for (final month in months.keys) {
    final txsInMonth = months[month];
    try {
      final insight = Insight(
        name: month,
        datetime: mmmyDateFormat.parse(month),
        txs: txsInMonth ?? [],
      );
      insights.add(insight);
    } catch (e) {
      // Probably Failed due to trying to parse a bad date
    }
  }
  return insights;
}

Map<String, List<Transaction>> groupTransactionsByMonth(
  Iterable<Transaction> txs,
) {
  return groupBy<Transaction, String>(
    txs,
    (obj) =>
        obj.dateTime != null ? mmmyDateFormat.format(obj.dateTime!) : 'Unknown',
  )..removeWhere((key, value) => key == 'Unknown');
}

Map<String, List<Transaction>> groupTransactionsByYear(
  Iterable<Transaction> txs,
) {
  return groupBy<Transaction, String>(
    txs,
    (obj) => obj.dateTime != null ? '${obj.dateTime!.year}' : 'Unknown',
  )..removeWhere((key, value) => key == 'Unknown');
}

List<Insight> buildYearlyInsights(Iterable<Transaction> txs) {
  final years = groupTransactionsByYear(txs);
  final insights = <Insight>[];
  for (final year in years.keys) {
    final txsInYear = years[year];
    try {
      final insight = Insight(
        name: year,
        datetime: DateTime.parse('$year-01-01'),
        txs: txsInYear ?? [],
      );
      insights.add(insight);
    } catch (e) {
      // Handle potential errors, such as parsing errors
    }
  }
  return insights;
}
