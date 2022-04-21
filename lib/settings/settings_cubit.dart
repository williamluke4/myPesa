import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_pesa/data/export.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/data/sheet_repository.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/settings/settings_state.dart';
import 'package:my_pesa/utils/load.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account == null && state.user != null) {
        // ignore: avoid_redundant_argument_values
        emit(state.signout());
      } else {
        emit(state.copyWith(user: account));
      }
    });
    signInSilently();
  }
  final _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'https://www.googleapis.com/auth/spreadsheets'],
  );

  Future<void> signInSilently() async {
    await _googleSignIn.signInSilently();
  }

  Future<void> signin() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      emit(
        state.copyWith(
          error: signInError,
        ),
      );
    }
  }

  Future<void> setThemeMode(ThemeMode value) async {
    emit(state.copyWith(themeMode: value));
  }

  Future<void> signout() async {
    await _googleSignIn.disconnect();
  }

  Future<void> exportToGoogleSheets() async {
    emit(state.copyWith(isLoading: true));
    if (state.transactions.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          error: noTransactionsError,
        ),
      );
      return;
    }
    if (state.user == null) {
      emit(
        state.copyWith(
          isLoading: false,
          error: notSignedInError,
        ),
      );
      return;
    }

    final authHeaders = await state.user!.authHeaders;
    final gsheets = SheetRepository(authHeaders: authHeaders);
    final spreadsheet = await gsheets.createSheet(
      transactions: state.transactions,
      type: state.exportType,
    );
    if (spreadsheet != null) {
      // TODO(williamluke4): Set SpreadsheetID
    }
    emit(state.copyWith(isLoading: false));
  }

  Future<void> setExportType(ExportType exportType) async {
    emit(state.copyWith(exportType: exportType));
  }

  Future<void> refreshTransactions() async {
    if (await Permission.sms.isGranted == false) {
      await Permission.sms.request();
    }
    // Loading of messages
    final transactions = await getTransactionsFromMessages('MPESA');
    // TODO: This is not efficient
    state.transactions.forEach((tx) {
      if (tx.category != unCategorized) {
        var idx = transactions.indexWhere((element) => element.ref == tx.ref);
        if (idx != -1) {
          transactions[idx] = transactions[idx].copyWith(category: tx.category);
        }
      }
    });
    emit(
      state.copyWith(
        transactions: transactions,
        balance: transactions[0].balance,
      ),
    );
  }

  Future<void> updateTrasactionCategory(String ref, Category category) async {
    final txIdx = state.transactions.indexWhere((tx) => tx.ref == ref);
    if (txIdx != -1) {
      final updatedTransactions = List<Transaction>.from(state.transactions);
      updatedTransactions[txIdx] =
          state.transactions[txIdx].copyWith(category: category);

      print("inserted ${updatedTransactions[txIdx].category.name}");
      emit(state.copyWith(transactions: updatedTransactions));
    } else {
      emit(
        state.copyWith(
          error: const UserError(message: 'Unable to Update Transaction'),
        ),
      );
    }
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json);
  @override
  Map<String, dynamic> toJson(state) => state.toJson();
}
