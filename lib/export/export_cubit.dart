import 'dart:convert';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/data/sheet_repository.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/export/export_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportCubit extends HydratedCubit<ExportState> {
  ExportCubit({required this.sheetRepository}) : super(const ExportState());
  SheetRepository sheetRepository;

  Future<void> remoteSheetId() async {
    emit(const ExportState());
  }

  Future<void> backup(
    List<Transaction> txs,
    List<Category> categories,
  ) async {
    emit(state.copyWith(isLoading: true));
    if (!Platform.isAndroid) {
      // ignore: only_throw_errors
      emit(
        state.copyWith(
          isLoading: false,
          error: const UserError(message: 'Only Supported on Android'),
        ),
      );
      return;
    }
    Directory? directory;
    directory = await getExternalStorageDirectory();

    if (directory == null || !directory.existsSync()) {
      state.copyWith(
        isLoading: false,
        error: const UserError(message: 'Could not find downloads directory'),
      );
      return;
    }

    final data = jsonEncode(
      {'transactions': txs, 'categories': categories, 'version': 1},
    );
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(now);
    final file = File('${directory.path}/mypesa-backup-$formattedDate.json');
    if (file.existsSync()) {
      emit(
        state.copyWith(
          isLoading: false,
          error: UserError(message: 'File Already Exists: ${file.path}'),
        ),
      );
      return;
    }
    await file.create(recursive: true);
    await file.writeAsString(data);
    emit(state.copyWith(isLoading: false));
    // url_launcher -> file:<path>
  }

  Future<void> openSheet() async {
    emit(state.copyWith(isLoading: true));
    if (state is ExportedState) {
      try {
        final _url = Uri.parse((state as ExportedState).spreadsheetUrl);
        await launchUrl(_url, mode: LaunchMode.externalApplication);
        // final spreadsheetUrl =
        //     'https://docs.google.com/spreadsheets/d/$spreadsheetId/edit#gid=0';
      } on UserError catch (e) {
        emit(state.copyWith(error: e));
      } finally {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  Future<void> readTransactions(
    GoogleSignInAccount user,
    String spreadsheetId,
  ) async {
    await sheetRepository.getTransactionsFromSheet(
      user: user,
      spreadsheetId: spreadsheetId,
    );
  }

  Future<void> setSpreadsheetId(String spreadsheetId) async {
    return emit(ExportedState(spreadsheetId: spreadsheetId));
  }

  Future<void> exportToGoogleSheets(
    GoogleSignInAccount user,
    List<Transaction> txs,
    List<Category> categories,
  ) async {
    emit(state.copyWith(isLoading: true));
    if (txs.isEmpty) {
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
      transactions: txs,
      categories: categories,
    );

    if (created.isSuccess() && created.getSuccess() != null) {
      emit(
        ExportedState(
          spreadsheetId: created.getSuccess()!.spreadsheetId,
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
