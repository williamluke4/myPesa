import 'package:charts_flutter/flutter.dart' as charts;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';

class CategoriesPieChart extends StatelessWidget {
  const CategoriesPieChart({
    Key? key,
    this.animate = true,
  }) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {
    final transactions = context.select<TransactionsCubit, List<Transaction>>(
      (settingsCubit) => settingsCubit.state.transactions,
    );
    final categories = context.select<CategoriesCubit, List<Category>>(
      (c) => c.state.categories,
    );
    final categoriesMap = {for (var e in categories) e.id: e};

    final dataset = buildTransactionDataSet(transactions, categoriesMap);

    return charts.PieChart(
      dataset,
      animate: animate,

      // Configure the width of the pie slices to 60px. The remaining space in
      // the chart will be left as a hole in the center.
      //
      // [ArcLabelDecorator] will automatically position the label inside the
      // arc if the label will fit. If the label will not fit, it will draw
      // outside of the arc with a leader line. Labels can always display
      // inside or outside using [LabelPosition].
      //
      // Text style for inside / outside can be controlled independently by
      // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
      //
      // Example configuring different styles for inside/outside:
      //       new charts.ArcLabelDecorator(
      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
      defaultRenderer: charts.ArcRendererConfig<String>(
        arcWidth: 20,
        arcRendererDecorators: [
          // charts.ArcLabelDecorator(
          //   labelPadding: 8,
          //   outsideLabelStyleSpec: const charts.TextStyleSpec(
          //     fontSize: 12,
          //     color: charts.MaterialPalette.white,
          //   ),
          // )
        ],
      ),
      behaviors: [
        charts.DatumLegend<String>(
          // Positions for "start" and "end" will be left and right respectively
          // for widgets with a build context that has directionality ltr.
          // For rtl, "start" and "end" will be right and left respectively.
          //
          // Since this example has directionality of ltr, the legend is
          // positioned on the right side of the chart.
          position: charts.BehaviorPosition.bottom,
          // By default, if the position of the chart is on the left or right of
          // the chart, [horizontalFirst] is set to false. This means that the
          // legend entries will grow as new rows first instead of a new column.
          horizontalFirst: false,
          // This defines the padding around each legend entry.
          cellPadding: const EdgeInsets.only(right: 4, bottom: 4),
          // Set show measures to true to display measures in series legend,
          // when the datum is selected.
          showMeasures: true,
        ),
      ],
    );
  }
}

List<charts.Series<CategoryData, String>> buildTransactionDataSet(
  List<Transaction> transactions,
  Map<String, Category> categoriesMap,
) {
  final groupedByCategory =
      groupBy<Transaction, String>(transactions, (obj) => obj.categoryId)
        ..remove(unCategorizedCategory.id);
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
