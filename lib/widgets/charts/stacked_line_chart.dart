/// Bar chart example
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final formatter = DateFormat('MMM y');

class StackedLineChart extends StatelessWidget {
  const StackedLineChart(this.seriesList, {super.key, this.animate = false});
  final List<ChartSeries> seriesList;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      series: seriesList,
      primaryXAxis: DateTimeCategoryAxis(dateFormat: formatter),
      zoomPanBehavior:
          ZoomPanBehavior(enablePinching: true, enablePanning: true),
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
    );
  }
}

class ChartData {
  ChartData(this.x, this.transactions)
      : y = transactions.fold(0, (sum, tx) {
          final value = tx.amount.replaceAll(',', '');
          final intValue = double.tryParse(value) ?? 0;
          return sum + intValue.toInt();
        });
  final DateTime x;
  final List<Transaction> transactions;
  final int y;
}

class TransactionsInMonth {
  TransactionsInMonth(
      this.dateTime, Map<String, Category> categoriesMap, this.transactions) {
    for (final entry in categoriesMap.entries) {
      final total = transactions
          .where((element) => element.categoryId == entry.key)
          .fold<int>(0, (sum, tx) {
        final value = tx.amount.replaceAll(',', '');
        final intValue = double.tryParse(value) ?? 0;
        return sum + intValue.toInt();
      });
      categoriesTotal[entry.key] = total;
    }
  }

  final DateTime dateTime;
  final Map<String, int> categoriesTotal = Map();
  final List<Transaction> transactions;
}

List<ChartSeries<TransactionsInMonth, DateTime>> buildLineChart(
  List<Transaction> transactions,
  Map<String, Category> categoriesMap,
) {
  final now = DateTime.now();
  final series = <ChartSeries<TransactionsInMonth, DateTime>>[];
  for (final entry in categoriesMap.entries) {}
  final filteredTxs = transactions
      .where((tx) => tx.dateTime != null && tx.type == TransactionType.OUT);

  final data = <TransactionsInMonth>[];

  groupBy<Transaction, DateTime>(
    filteredTxs,
    (obj) => DateTime(obj.dateTime!.year, obj.dateTime!.month, 1),
  ).forEach((yearMonth, txs) {
    data.add(TransactionsInMonth(yearMonth, categoriesMap, txs));
  });
  for (final entry in categoriesMap.entries) {
    series.add(StackedAreaSeries(
      dataSource: data,
      color: colorFrom(entry.value.name),
      groupName: entry.value.name,
      name: entry.value.name,
      xValueMapper: (TransactionsInMonth data, _) => data.dateTime,
      yValueMapper: (TransactionsInMonth data, _) =>
          data.categoriesTotal[entry.key],
    ));
  }

  return series;
}

Color colorFrom(String text) {
  var hash = 0;
  for (var i = 0; i < text.length; i++) {
    hash = text.codeUnitAt(i) + ((hash << 5) - hash);
  }
  final finalHash = hash.abs() % (256 * 256 * 256);
  final red = (finalHash & 0xFF0000) >> 16;
  final blue = (finalHash & 0xFF00) >> 8;
  final green = finalHash & 0xFF;
  return Color.fromRGBO(red, green, blue, 1);
}
