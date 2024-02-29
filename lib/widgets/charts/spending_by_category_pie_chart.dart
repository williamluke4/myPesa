import 'package:flutter/material.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/utils/color.dart';
import 'package:my_pesa/utils/insights.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpendingByCategoryPieChart extends StatelessWidget {
  const SpendingByCategoryPieChart({
    super.key,
    required this.insight,
    required this.title,
    required this.totalSpending,
    required this.valueMapper,
    required this.dataSource,
    required this.categoriesMap,
  });

  final Insight insight;
  final String title;
  final List<CategoryInsight> dataSource;
  final int Function(CategoryInsight) valueMapper;
  final int totalSpending;

  final Map<String, Category> categoriesMap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SfCircularChart(
        title: ChartTitle(text: title),
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            height: '100%',
            width: '100%',
            widget: PhysicalModel(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(
                230,
                230,
                230,
                1,
              ),
              child: Container(),
            ),
          ),
          CircularChartAnnotation(
            widget: Text(
              '$totalSpending',
              style: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                fontSize: 25,
              ),
            ),
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <DoughnutSeries<CategoryInsight, String>>[
          DoughnutSeries<CategoryInsight, String>(
            dataSource: dataSource,
            animationDuration: 0,
            pointColorMapper: (datum, index) => colorFrom(datum.categoryId),
            xValueMapper: (CategoryInsight data, _) =>
                categoriesMap[data.categoryId]?.name ?? 'Unknown',
            yValueMapper: (CategoryInsight data, _) => valueMapper(data),
            name: title,
            dataLabelMapper: (
              CategoryInsight data,
              _,
            ) =>
                categoriesMap[data.categoryId]?.name ?? 'Unknown',
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              showZeroValue: false,
              labelPosition: ChartDataLabelPosition.outside,
            ),
          ),
        ],
      ),
    );
  }
}
