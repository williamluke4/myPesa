import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_pesa/data/export.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/data/sheet_repository.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/export/export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  ExportCubit({required this.sheetRepository}) : super(const ExportState());
  SheetRepository sheetRepository;

  Future<void> exportToGoogleSheets(
    List<Transaction> txs,
    ExportType exportType,
  ) async {
    if (txs.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          error: noTransactionsError,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true));
    final spreadsheet = await sheetRepository.createSheet(
      transactions: txs,
      type: exportType,
    );
    if (spreadsheet != null) {
      emit(
        ExportedState(
          spreadsheetId: spreadsheet.spreadsheetId,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          error: const UserError(message: 'Oops Somthing When Wrong'),
        ),
      );
    }
  }
}
