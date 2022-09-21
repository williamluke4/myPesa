import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/export/export_cubit.dart';
import 'package:my_pesa/export/export_state.dart';
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
        final categories = context.read<CategoriesCubit>().state.categories;
        if (state.isLoading) {
          return const CircularProgressIndicator.adaptive();
        } else {
          return Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed:
                        (state is ExportedState && state.spreadsheetId != null)
                            ? () {
                                context.read<ExportCubit>().openSheet();
                              }
                            : null,
                    child: const Text('Open Spreadsheet'),
                  ),
                  ElevatedButton(
                    onPressed: () => context
                        .read<ExportCubit>()
                        .exportToGoogleSheets(transactions, categories),
                    child: const Text('Export to Google Sheets'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => context
                    .read<ExportCubit>()
                    .backup(transactions, categories),
                child: const Text('Backup'),
              ),
            ],
          );
        }
      },
    );
  }
}
