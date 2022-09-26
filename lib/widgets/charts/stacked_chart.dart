/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:my_pesa/utils/charts.dart';

class StackedBarChart extends StatelessWidget {
  const StackedBarChart(this.seriesList, {super.key, this.animate = false});
  final List<charts.Series<CategoryData, String>> seriesList;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.groupedStacked,
      barRendererDecorator: charts.BarLabelDecorator(
        labelPadding: 8,
        outsideLabelStyleSpec: const charts.TextStyleSpec(
          fontSize: 12,
          color: charts.MaterialPalette.black,
        ),
      ),
      behaviors: [
        charts.SeriesLegend(
          position: charts.BehaviorPosition.bottom,
          horizontalFirst: false,
          desiredMaxRows: 5,
          showMeasures: true,
          cellPadding: const EdgeInsets.only(right: 2, bottom: 4),
        )
      ],
    );
  }
}
