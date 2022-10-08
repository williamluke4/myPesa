import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/cubits/export/export_cubit.dart';
import 'package:my_pesa/cubits/export/export_state.dart';
import 'package:my_pesa/cubits/settings/settings_cubit.dart';

class ExportView extends StatelessWidget {
  const ExportView({super.key});

  Future<void> _handleImport(
    BuildContext context, [
    bool mounted = true,
  ]) async {
    if (!mounted) return;
    await context.read<DatabaseCubit>().import();
  }

  Future<void> _handleDelete(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Are You Sure?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Noop'),
          ),
          TextButton(
            onPressed: () {
              context.read<DatabaseCubit>().reset();
              Navigator.pop(context);
            },
            child: const Text('Yes Delete it'),
          ),
        ],
      ),
    );
  }

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
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (state.success != null) {
          final snackBar = SnackBar(
            content: Text(
              state.success!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.greenAccent,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        final transactions = context.read<DatabaseCubit>().state.transactions;
        final categories = context.read<DatabaseCubit>().state.categories;

        final user = context
            .select<SettingsCubit, GoogleSignInAccount?>((s) => s.state.user);

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
                    child: const Text('Open Last Export'),
                  ),
                  ElevatedButton(
                    onPressed: user == null
                        ? null
                        : () =>
                            context.read<ExportCubit>().exportToGoogleSheets(
                                  user,
                                  transactions,
                                  categories,
                                ),
                    child: const Text('Export to Google Sheets'),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => context.read<DatabaseCubit>().backup(),
                    child: const Text('Backup'),
                  ),
                  ElevatedButton(
                    onPressed: () => _handleImport(context),
                    child: const Text('Import'),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _handleDelete(context),
                    child: const Text('Delete All Data'),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
