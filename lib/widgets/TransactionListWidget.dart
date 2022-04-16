import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/data/models/Transaction.dart';
import 'package:my_pesa/settings/settings_cubit.dart';
import 'package:my_pesa/widgets/TransactionRowWidget.dart';

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({
    Key? key,
    required this.transactions,
    required this.disabled,
  }) : super(key: key);
  final List<Transaction> transactions;
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    final groupedByDate =
        groupBy<Transaction, String>(transactions, (obj) => obj.date);
    final dates = groupedByDate.keys.toList();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: RefreshIndicator(
        onRefresh: () => context.read<SettingsCubit>().refreshTransactions(),
        child: ListView.builder(
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final transactions = groupedByDate[dates[index]];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dates[index],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ...transactions!.map<TransactionRowWidget>(
                  (tx) => TransactionRowWidget(
                    transaction: tx,
                    disabled: disabled,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
