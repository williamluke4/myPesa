import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';
import 'package:my_pesa/utils/insights.dart';
import 'package:my_pesa/widgets/charts/stacked_line_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final transactions = context.select<TransactionsCubit, List<Transaction>>(
      (c) => c.state.transactions,
    );
    final categories = context.select<CategoriesCubit, List<Category>>(
      (c) => c.state.categories,
    );
    final categoriesMap = {for (var e in categories) e.id: e};
    // Add Date Range Filter for Transactions
    // Use Pie Chart To Display Monthly Spending and Income by category
    // Do something clever to spit out insights of monthly data
    final insights = buildInsights(transactions);
    num kMinWidthOfLargeScreen = 600;
    bool isScreenWide =
        MediaQuery.of(context).size.width >= kMinWidthOfLargeScreen;

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
            return Column(
              children: [
                Text(insight.name),
                SizedBox(
                  height: isScreenWide ? 400 : 700,
                  child: Flex(
                    direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                    children: [
                      Expanded(
                        child: SfCircularChart(
                          annotations: <CircularChartAnnotation>[
                            CircularChartAnnotation(
                                height: '100%',
                                width: '100%',
                                widget: PhysicalModel(
                                  shape: BoxShape.circle,
                                  elevation: 10,
                                  color: const Color.fromRGBO(230, 230, 230, 1),
                                  child: Container(),
                                )),
                            CircularChartAnnotation(
                                widget: Text('${insight.total.incoming}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 0.5),
                                        fontSize: 25)))
                          ],
                          title: ChartTitle(text: 'Income'),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <DoughnutSeries<CategoryInsight, String>>[
                            DoughnutSeries<CategoryInsight, String>(
                              dataSource: insight.categories
                                  .where(
                                      (element) => element.total.incoming != 0)
                                  .toList(),
                              xValueMapper: (CategoryInsight data, _) =>
                                  categoriesMap[data.categoryId]?.name ??
                                  'Unknown',
                              yValueMapper: (CategoryInsight data, _) =>
                                  data.total.incoming,
                              pointColorMapper: (datum, index) =>
                                  colorFrom(datum.categoryId),
                              name: 'Income',
                              sortingOrder: SortingOrder.descending,
                              dataLabelMapper: (CategoryInsight data, _) =>
                                  categoriesMap[data.categoryId]?.name ??
                                  'Unknown',
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                showZeroValue: false,
                                labelPosition: ChartDataLabelPosition.outside,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: SfCircularChart(
                            title: ChartTitle(text: 'Expenses'),
                            annotations: <CircularChartAnnotation>[
                              CircularChartAnnotation(
                                  height: '100%',
                                  width: '100%',
                                  widget: PhysicalModel(
                                    shape: BoxShape.circle,
                                    elevation: 10,
                                    color:
                                        const Color.fromRGBO(230, 230, 230, 1),
                                    child: Container(),
                                  )),
                              CircularChartAnnotation(
                                  widget: Text('${insight.total.outgoing}',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.5),
                                          fontSize: 25)))
                            ],
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <DoughnutSeries<CategoryInsight, String>>[
                              DoughnutSeries<CategoryInsight, String>(
                                dataSource: insight.categories
                                    .where((element) =>
                                        element.total.outgoing != 0)
                                    .toList(),
                                pointColorMapper: (datum, index) =>
                                    colorFrom(datum.categoryId),
                                xValueMapper: (CategoryInsight data, _) =>
                                    categoriesMap[data.categoryId]?.name ??
                                    'Unknown',
                                yValueMapper: (CategoryInsight data, _) =>
                                    data.total.outgoing,
                                name: 'Expense',
                                dataLabelMapper: (CategoryInsight data, _) =>
                                    categoriesMap[data.categoryId]?.name ??
                                    'Unknown',
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  showZeroValue: false,
                                  labelPosition: ChartDataLabelPosition.outside,
                                ),
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// StackedBarChart(buildChartSeries(transactions, categoriesMap)),
