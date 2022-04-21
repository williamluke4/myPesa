import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/settings/settings_cubit.dart';
import 'package:my_pesa/settings/settings_state.dart';

import '../helpers/hydrated_bloc.dart';

void main() {
  group('SettingsCubit', () {
    SettingsCubit build({Storage? storage}) => HydratedBlocOverrides.runZoned(
          SettingsCubit.new,
          storage: storage ?? MockStorage(),
        );

    test('check state equality ', () {
      mockHydratedStorage(() {
        expect(SettingsCubit().state, SettingsCubit().state);
      });
    });

    blocTest<SettingsCubit, SettingsState>(
      'emits [themeMode: ThemeMode.dark] when setThemeMode',
      build: build,
      act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
      expect: () => [const SettingsState(themeMode: ThemeMode.dark)],
    );
    blocTest<SettingsCubit, SettingsState>(
      '''
emits [error: noTransactionsError] when exportToGoogleSheets with no transactions''',
      build: build,
      act: (cubit) => cubit.exportToGoogleSheets(),
      expect: () => [
        const SettingsState(isLoading: true),
        SettingsState(error: noTransactionsError)
      ],
    );
  });
}
