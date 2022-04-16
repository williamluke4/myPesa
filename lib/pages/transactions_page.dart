import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/settings/settings_cubit.dart';
import 'package:my_pesa/settings/settings_state.dart';
import 'package:my_pesa/widgets/BalanceWidget.dart';
import 'package:my_pesa/widgets/TransactionListWidget.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.transactions != null && state.transactions!.isNotEmpty) {
          return Column(
            children: <Widget>[
              BalanceWidget(balance: state.balance ?? ''),
              
              if (state.isLoading)
                ElevatedButton(
                  onPressed: () =>
                      context.read<SettingsCubit>().exportToGoogleSheets(),
                  child: const Text('Export'),
                )
              else
                const CircularProgressIndicator.adaptive(),

              Expanded(
                child: TransactionListWidget(
                  disabled: false,
                  transactions: state.transactions ?? [],
                ),
              ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
