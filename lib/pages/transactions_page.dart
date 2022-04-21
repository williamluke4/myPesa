import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/settings/settings_cubit.dart';
import 'package:my_pesa/settings/settings_state.dart';
import 'package:my_pesa/widgets/balance_widget.dart';
import 'package:my_pesa/widgets/transaction_list_widget.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (BuildContext context, SettingsState state) {
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
            BalanceWidget(balance: state.balance),
            if (state.isLoading)
              const CircularProgressIndicator.adaptive()
            else
              ElevatedButton(
                onPressed: () =>
                    context.read<SettingsCubit>().exportToGoogleSheets(),
                child: const Text('Export'),
              ),
            Expanded(
              child: TransactionListWidget(
                disabled: false,
                transactions: state.transactions,
              ),
            ),
          ],
        );
      },
    );
  }
}
