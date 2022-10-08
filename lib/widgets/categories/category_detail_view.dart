import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/pages/transaction_page.dart';
import 'package:my_pesa/utils/datetime.dart';
import 'package:my_pesa/utils/insights.dart';
import 'package:my_pesa/widgets/transactions/transaction_list_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryDetailsView extends StatelessWidget {
  const CategoryDetailsView({
    super.key,
    required this.category,
  });

  final Category category;

  Widget _buildBarChart(List<Transaction> txs) {
    final insights = buildInsights(txs);
    return SfCartesianChart(
      primaryXAxis: DateTimeCategoryAxis(dateFormat: mmmyDateFormat),
      series: <ColumnSeries<Insight, DateTime>>[
        ColumnSeries<Insight, DateTime>(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
          dataSource: insights,
          xValueMapper: (Insight data, _) => data.datetime,
          yValueMapper: (Insight data, _) => data.total.incoming,
          name: 'Income',
        ),
        ColumnSeries<Insight, DateTime>(
          dataSource: insights,
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
          xValueMapper: (Insight data, _) => data.datetime,
          yValueMapper: (Insight data, _) => data.total.outgoing,
          name: 'Expense',
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = context.select<DatabaseCubit, List<Transaction>>(
      (c) => c.state.transactions,
    );
    final categoryTransactions =
        transactions.where((element) => element.categoryId == category.id);

    return Column(
      children: <Widget>[
        Container(
          height: 200,
          padding: const EdgeInsets.all(8),
          child: _buildBarChart(categoryTransactions.toList()),
        ),
        Expanded(
          child: TransactionListWidget(
            onTransactionTap: (tx) {
              Navigator.push(
                context,
                MaterialPageRoute<Widget>(
                  builder: (context) => TransactionPage(
                    key: key,
                    txRef: tx.ref,
                  ),
                ),
              );
            },
            showCategories: false,
            transactions: categoryTransactions.toList(),
          ),
        ),
      ],
    );
  }
}
