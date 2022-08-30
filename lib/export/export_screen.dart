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
        }
        if (state is ExportedState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  context.read<ExportCubit>().openSheet();
                },
                child: const Text('Open Spreadsheet'),
              ),
              const ElevatedButton(
                onPressed: null,
                child: Text('Sync'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<ExportCubit>().remoteSheetId();
                },
                child: const Text('Clear'),
              ),
            ],
          );
        }
        return Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showBottomSheet<Widget>(
                  context: context,
                  builder: (c) {
                    return TextField(
                      onSubmitted: (value) {
                        context.read<ExportCubit>().setSpreadsheetId(value);
                        Navigator.pop(context);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Spreadsheet ID',
                      ),
                    );
                  },
                );
              },
              child: const Text('Enter Spreadsheet ID'),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<ExportCubit>()
                    .createAndExport(transactions, categories);
              },
              child: const Text('Create Spreadsheet'),
            ),
          ],
        );
      },
    );
  }
}
