import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_pesa/data/export.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/settings/settings_state.dart';
import 'package:my_pesa/utils/logger.dart';

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
    try {
      await _googleSignIn.signInSilently();
    } catch (error) {
      log.d(error);
      emit(
        state.copyWith(
          error: signInError,
        ),
      );
    }
    await _googleSignIn.signInSilently();
  }

  Future<void> signin() async {
    log.i('Trying to signin');

    try {
      await _googleSignIn.signIn();
    } catch (error) {
      log.i(error.toString());
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

  Future<void> setExportType(ExportType exportType) async {
    emit(state.copyWith(exportType: exportType));
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    log.e('Error: $error', [stackTrace]);
    super.onError(error, stackTrace);
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json);

  @override
  Map<String, dynamic> toJson(SettingsState state) => state.toJson(state);
}
