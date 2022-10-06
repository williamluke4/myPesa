import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/data/sheet_repository.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/export/export_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportCubit extends HydratedCubit<ExportState> {
  ExportCubit({required this.sheetRepository}) : super(const ExportState());
  SheetRepository sheetRepository;

  Future<void> remoteSheetId() async {
    emit(const ExportState());
  }

  Future<Tuple2<List<Transaction>, List<Category>>?> import() async {
    String? filePath;
    if (Platform.isAndroid || Platform.isIOS) {
      filePath = await FlutterFileDialog.pickFile(
        params: const OpenFileDialogParams(),
      );
    } else {
      final result = await FilePicker.platform.pickFiles();
      filePath = result?.files.single.path;
    }

    if (filePath != null) {
      final file = File(filePath);
      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final t = data['transactions'] as List<dynamic>;
      final c = data['categories'] as List<dynamic>;
      final transactions = t
          .map((dynamic e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList();
      final categories = c
          .map((dynamic e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(
        state.copyWith(
          success:
              // ignore: lines_longer_than_80_chars
              'Found ${transactions.length} Transactions and ${categories.length} Categories',
        ),
      );
      return Tuple2(transactions, categories);
    } else {
      // User canceled the picker
      return null;
    }
  }

  Future<void> backup(
    List<Transaction> txs,
    List<Category> categories,
  ) async {
    emit(state.copyWith(isLoading: true));

    final directory = await getTemporaryDirectory();

    final data = jsonEncode(
      {'transactions': txs, 'categories': categories, 'version': 1},
    );
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(now);
    final fileName = 'mypesa-backup-$formattedDate.json';

    String? filePath;
    if (Platform.isAndroid || Platform.isAndroid) {
      final file = File('${directory.path}/$fileName');
      if (file.existsSync()) file.deleteSync();

      await file.create(recursive: true);
      await file.writeAsString(data);
      filePath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(sourceFilePath: file.path),
      );
    } else {
      filePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Where would you like it:',
        fileName: fileName,
      );
      if (filePath != null) {
        final file = File(filePath);
        await file.create(recursive: true);
        await file.writeAsString(data);
      }
    }
    if (filePath == null) {
      emit(
        state.copyWith(
          isLoading: false,
          error: const UserError(message: 'Oops something went wrong'),
        ),
      );
    } else {
      emit(
        state.copyWith(isLoading: false, success: 'Backup Saved to $filePath'),
      );
    }

    // url_launcher -> file:<path>
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
