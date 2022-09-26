import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:my_pesa/utils/charts.dart';

class PieChart extends StatelessWidget {
  const PieChart({
    Key? key,
    required this.dataset,
    this.animate = true,
  }) : super(key: key);

  final bool animate;

  final List<charts.Series<CategoryData, String>> dataset;

  @override
  Widget build(BuildContext context) {
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
          charts.ArcLabelDecorator(
            labelPadding: 8,
            outsideLabelStyleSpec: const charts.TextStyleSpec(
              fontSize: 12,
              color: charts.MaterialPalette.white,
            ),
          )
        ],
      ),
    );
  }
}
