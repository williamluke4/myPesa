import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/utils/insights.dart';
import 'package:my_pesa/widgets/insights/monthly_insights.dart';
import 'package:my_pesa/widgets/insights/yearly_insights.dart';

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
    final categoriesMap = {for (final e in categories) e.id: e};

    final monthlyInsights = buildMonthlyInsights(transactions);
    final yearlyInsights = buildYearlyInsights(transactions);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Monthly'),
              Tab(text: 'Annual'),
            ],
          ),
          title: const Text('Insights'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: TabBarView(
            children: [
              ListView.builder(
                itemCount: monthlyInsights.length,
                itemBuilder: (context, insightIdx) {
                  final insight = monthlyInsights[insightIdx];
                  return MonthlyInsight(
                    insight: insight,
                    categoriesMap: categoriesMap,
                  );
                },
              ),
              ListView.builder(
                itemCount: yearlyInsights.length,
                itemBuilder: (context, insightIdx) {
                  final insight = yearlyInsights[insightIdx];
                  return YearlyInsight(
                    insight: insight,
                    categoriesMap: categoriesMap,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
