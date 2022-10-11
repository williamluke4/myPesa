import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/utils/color.dart';
import 'package:my_pesa/utils/insights.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final transactions = context.select<DatabaseCubit, List<Transaction>>(
      (c) => c.state.transactions,
    );
    final categories = context.select<DatabaseCubit, List<Category>>(
      (c) => c.state.categories,
    );
    final categoriesMap = {for (var e in categories) e.id: e};

    final insights = buildInsights(transactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: insights.length,
          itemBuilder: (context, insightIdx) {
            final insight = insights[insightIdx];
            return MonthlyInsight(
              insight: insight,
              categoriesMap: categoriesMap,
            );
          },
        ),
      ),
    );
  }
}

class MonthlyInsight extends StatelessWidget {
  const MonthlyInsight({
    super.key,
    required this.insight,
    required this.categoriesMap,
  });

  final Insight insight;
  final Map<String, Category> categoriesMap;

  @override
  Widget build(BuildContext context) {
    final isScreenWide = MediaQuery.of(context).size.width >= 600;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            insight.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: isScreenWide ? 400 : 700,
          child: Flex(
            direction: isScreenWide ? Axis.horizontal : Axis.vertical,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SpendingByCategoryPieChart(
                    insight: insight,
                    title: 'Income',
                    valueMapper: (c) => c.total.incoming,
                    totalSpending: insight.total.incoming,
                    dataSource: insight.categories
                        .where((element) => element.total.incoming != 0)
                        .toList(),
                    categoriesMap: categoriesMap,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SpendingByCategoryPieChart(
                    insight: insight,
                    title: 'Expenses',
                    valueMapper: (c) => c.total.outgoing,
                    totalSpending: insight.total.outgoing,
                    dataSource: insight.categories
                        .where((element) => element.total.outgoing != 0)
                        .toList(),
                    categoriesMap: categoriesMap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
              elevation: 10,
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
          )
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <DoughnutSeries<CategoryInsight, String>>[
          DoughnutSeries<CategoryInsight, String>(
            dataSource: dataSource,
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
          )
        ],
      ),
    );
  }
}
