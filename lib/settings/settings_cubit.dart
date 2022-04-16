import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pesa/data/sheet_repository.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/settings/settings_state.dart';
import 'package:my_pesa/utils/load.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account == null) {
        emit(state.copyWith(user: null));
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
      emit(state.copyWith(error: AuthError(error: error)));
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
    if (state.transactions != null &&
        state.transactions!.isNotEmpty &&
        state.user != null) {
      final authHeaders = await state.user!.authHeaders;
      final gsheets = SheetRepository(authHeaders: authHeaders);
      final spreadsheet =
          await gsheets.createSheet(transactions: state.transactions!);
      if (spreadsheet != null) {
        print(spreadsheet.spreadsheetId);
      }
    }
    emit(state.copyWith(isLoading: false, error: AuthError()));
  }

  Future<void> refreshTransactions() async {
    if (await Permission.sms.isGranted == false) {
      await Permission.sms.request();
    }
    // Loading of messages
    final transactions = await getTransactionsFromMessages('MPESA');
    emit(
      state.copyWith(
        transactions: transactions,
        balance: transactions[0].balance,
      ),
    );
  }
}
