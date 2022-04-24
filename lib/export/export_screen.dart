import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/export/export_cubit.dart';
import 'package:my_pesa/export/export_state.dart';
import 'package:my_pesa/settings/settings_cubit.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';

class ExportView extends StatelessWidget {
  const ExportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExportCubit, ExportState>(
      listener: (BuildContext context, ExportState state) {
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
        final transactions =
            context.read<TransactionsCubit>().state.transactions;
        final exportType = context.read<SettingsCubit>().state.exportType;

        return Column(
          children: <Widget>[
            if (state.isLoading)
              const CircularProgressIndicator.adaptive()
            else
              ElevatedButton(
                onPressed: () => context
                    .read<ExportCubit>()
                    .exportToGoogleSheets(transactions, exportType),
                child: const Text('Export'),
              ),
          ],
        );
      },
    );
  }
}
