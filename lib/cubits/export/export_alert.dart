import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/cubits/export/export_cubit.dart';
import 'package:my_pesa/cubits/settings/settings_cubit.dart';

class ExportAlert extends StatefulWidget {
  const ExportAlert({super.key});

  @override
  ExportAlertState createState() => ExportAlertState();
}

class ExportAlertState extends State<ExportAlert> {
  DateTime startDate = DateTime(DateTime.now().year);
  DateTime endDate = DateTime.now();
  bool separateTransactionFees = false;
  bool debugMode = false;

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: startDate,
        end: endDate,
      ),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = context.read<DatabaseCubit>().state.transactions;
    final categories = context.read<DatabaseCubit>().state.categories;

    final user = context
        .select<SettingsCubit, GoogleSignInAccount?>((s) => s.state.user);
    return AlertDialog(
      title: const Text('Export Options'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Date Range:'),
              const SizedBox(width: 10),
              Text(
                '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}',
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _selectDateRange,
                child: const Text('Select'),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Separate Transaction Fees:'),
              const SizedBox(width: 10),
              Switch(
                value: separateTransactionFees,
                onChanged: (value) {
                  setState(() {
                    separateTransactionFees = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('Debug:'),
              const SizedBox(width: 10),
              Switch(
                value: debugMode,
                onChanged: (value) {
                  setState(() {
                    debugMode = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<ExportCubit>().exportToGoogleSheets(
                  user,
                  transactions,
                  categories,
                  separateTransactionFees: separateTransactionFees,
                  debugMode: debugMode,
                  startDate: startDate,
                  endDate: endDate,
                );

            Navigator.of(context).pop();
          },
          child: const Text('Export'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
