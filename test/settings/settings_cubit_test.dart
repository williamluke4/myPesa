import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/settings/settings_cubit.dart';
import 'package:my_pesa/settings/settings_state.dart';

void main() {
  group('SettingsCubit', () {
    test('initial state is ', () {
      expect(SettingsCubit().state, equals(SettingsCubit()));
    });

    blocTest<SettingsCubit, SettingsState>(
      'emits [themeMode: ThemeMode.dark] when setThemeMode',
      build: SettingsCubit.new,
      act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
      expect: () => [const SettingsState(themeMode: ThemeMode.dark)],
    );
    blocTest<SettingsCubit, SettingsState>(
      'emits [error: noTransactionsError] when exportToGoogleSheets with no transactions',
      build: SettingsCubit.new,
      act: (cubit) => cubit.exportToGoogleSheets(),
      expect: () => [
        const SettingsState(isLoading: true),
        SettingsState(error: noTransactionsError)
      ],
    );
  });
}
