import 'package:charts_flutter/flutter.dart' as charts;
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';

List<charts.Series<CategoryData, String>> buildPieChartDataSet(
  List<Transaction> transactions,
  Map<String, Category> categoriesMap,
) {
  final groupedByCategory = groupBy<Transaction, String>(
    transactions,
    (obj) => obj.categoryId,
  )..remove(Category.none().id);
  final categoriesKeys = groupedByCategory.keys.toList();
  var idx = 0;
  final data = categoriesKeys.map((categoryKey) {
    final txs = groupedByCategory[categoryKey];
    final cd = CategoryData(
      idx,
      categoriesMap[categoryKey]?.name ?? 'Unknown Category',
      txs ?? [],
    );
    idx++;
    return cd;
  }).toList();
  return [
    charts.Series<CategoryData, String>(
      id: 'Categories',
      domainFn: (CategoryData sales, _) => sales.name,
      measureFn: (CategoryData sales, _) => sales.total,
      data: data,
      // Set a label accessor to control the text of the arc label.
      labelAccessorFn: (CategoryData row, _) => '${row.name}: ${row.total}',
      colorFn: (CategoryData sales, _) => colorFor(sales.name),
    )
  ];
}

List<charts.Series<CategoryData, String>> buildChartSeries(
  List<Transaction> transactions,
  Map<String, Category> categoriesMap,
) {
  // final now = DateTime.now();
  // final from = DateTime(now.year, now.month - 3);
  final formatter = DateFormat('MMM y');
  final series = <charts.Series<CategoryData, String>>[];
  // final filteredTxs = transactions
  //     .where((tx) => tx.dateTime != null && tx.dateTime!.isAfter(from));
  groupBy<Transaction, String>(
    transactions,
    (tx) => tx.type.name,
  ).forEach((type, groupedByType) {
    groupBy<Transaction, String>(
      groupedByType,
      (tx) => categoriesMap[tx.categoryId]?.name ?? 'Unknown Category',
    ).forEach((category, txsInCategory) {
      var idx = 0;
      final data = <CategoryData>[];

      groupBy<Transaction, String>(
        txsInCategory,
        (obj) =>
            obj.dateTime != null ? formatter.format(obj.dateTime!) : 'Unknown',
      ).forEach((key, txs) {
        data.add(CategoryData(idx, key, txs));
        idx++;
      });

      series.add(
        charts.Series<CategoryData, String>(
          id: category,
          seriesCategory: type,
          domainFn: (CategoryData d, _) => d.name,
          measureFn: (CategoryData d, _) => d.total,
          data: data,
          labelAccessorFn: (CategoryData row, _) => '$category: ${row.total}',
          colorFn: (CategoryData d, _) => colorFor(category),
        ),
      );
    });
  });
  return series;
}

class CategoryData {
  CategoryData(this.idx, this.name, this.transactions)
      : total = transactions.fold(0, (sum, tx) {
          final value = tx.amount.replaceAll(',', '');
          final intValue = double.tryParse(value) ?? 0;
          return sum + intValue.toInt();
        });
  final int idx;
  final String name;
  final List<Transaction> transactions;
  final int total;
}

charts.Color colorFor(String text) {
  var hash = 0;
  for (var i = 0; i < text.length; i++) {
    hash = text.codeUnitAt(i) + ((hash << 5) - hash);
  }
  final finalHash = hash.abs() % (256 * 256 * 256);
  final red = (finalHash & 0xFF0000) >> 16;
  final blue = (finalHash & 0xFF00) >> 8;
  final green = finalHash & 0xFF;
  final rhex = red.toRadixString(16).padLeft(2, '0');
  final ghex = green.toRadixString(16).padLeft(2, '0');
  final bhex = blue.toRadixString(16).padLeft(2, '0');
  final hexCode = '#$rhex$ghex$bhex';
  return charts.Color.fromHex(
    code: hexCode,
  );
}
