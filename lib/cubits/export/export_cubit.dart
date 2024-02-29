import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_pesa/cubits/export/export_state.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/data/sheet_repository.dart';
import 'package:my_pesa/errors.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportCubit extends HydratedCubit<ExportState> {
  ExportCubit({required this.sheetRepository}) : super(const ExportState());
  SheetRepository sheetRepository;

  Future<void> remoteSheetId() async {
    emit(const ExportState());
  }

  Future<void> openSheet() async {
    emit(state.copyWith(isLoading: true));
    if (state is ExportedState) {
      try {
        final url = Uri.parse((state as ExportedState).spreadsheetUrl);
        await launchUrl(url, mode: LaunchMode.externalApplication);
        // final spreadsheetUrl =
        //     'https://docs.google.com/spreadsheets/d/$spreadsheetId/edit#gid=0';
      } on UserError catch (e) {
        emit(state.copyWith(error: e));
      } finally {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  Future<void> setSpreadsheetId(String spreadsheetId) async {
    return emit(ExportedState(spreadsheetId: spreadsheetId));
  }

  Future<void> exportToGoogleSheets(
    GoogleSignInAccount? user,
    List<Transaction> txs,
    List<Category> categories, {
    bool separateTransactionFees = false,
    bool debugMode = false,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (user == null) {
      emit(
        state.copyWith(
          error: const UserError(message: 'User is not logged in'),
        ),
      );
      return;
    }
    emit(state.copyWith(isLoading: true));
    List<Transaction> filteredTxs;
    if (startDate != null && endDate != null) {
      final startDateStartOfDay =
          DateTime(startDate.year, startDate.month, startDate.day);
      final endDateEndOfDay =
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
      filteredTxs = txs.where((tx) {
        return tx.dateTime != null &&
            tx.dateTime!.isAfter(startDateStartOfDay) &&
            tx.dateTime!.isBefore(endDateEndOfDay);
      }).toList();
    } else {
      filteredTxs = txs;
    }
    if (filteredTxs.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          error: noTransactionsError,
        ),
      );
      return;
    }

    final created = await sheetRepository.createSheet(
      user: user,
      transactions: filteredTxs,
      categories: categories,
      separateTransactionFees: separateTransactionFees,
      debugMode: debugMode,
    );

    if (created.isSuccess() && created.tryGetSuccess() != null) {
      emit(
        ExportedState(
          spreadsheetId: created.tryGetSuccess()!.spreadsheetId,
          success: 'Export Success',
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          error: const UserError(message: 'Oops Something When Wrong'),
        ),
      );
    }
  }

  @override
  ExportState? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return const ExportState();
    } else {
      return ExportedState(
        spreadsheetId: json['spreadsheetId'] as String,
      );
    }
  }

  @override
  Map<String, dynamic>? toJson(ExportState state) {
    if (state is ExportedState) {
      return <String, dynamic>{
        'spreadsheetId': state.spreadsheetId,
      };
    } else {
      return null;
    }
  }
}
