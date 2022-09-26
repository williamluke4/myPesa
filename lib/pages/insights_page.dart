import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';
import 'package:my_pesa/widgets/charts/stacked_line_chart.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final transactions = context.select<TransactionsCubit, List<Transaction>>(
      (settingsCubit) => settingsCubit.state.transactions,
    );
    final categories = context.select<CategoriesCubit, List<Category>>(
      (c) => c.state.categories,
    );
    final categoriesMap = {for (var e in categories) e.id: e};
    // Add Date Range Filter for Transactions
    // Use Pie Chart To Display Monthly Spending and Income by category
    // Do something clever to spit out insights of monthly data

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StackedLineChart(buildLineChart(transactions, categoriesMap))),
    );
  }
}
