import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/pages/transaction_page.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';
import 'package:my_pesa/transactions/view/transaction_list_widget.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionsCubit, TransactionsState>(
      listener: (BuildContext context, TransactionsState state) {
        if (state.error != null) {
          final snackBar = SnackBar(
            content: Text(
              state.error!.message,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return Column(
          children: <Widget>[
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
                transactions: state.transactions,
              ),
            ),
          ],
        );
      },
    );
  }
}
