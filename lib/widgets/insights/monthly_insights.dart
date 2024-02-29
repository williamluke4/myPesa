import 'package:flutter/material.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/utils/insights.dart';
import 'package:my_pesa/widgets/charts/spending_by_category_pie_chart.dart';

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
