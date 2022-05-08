import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/data/export.dart';
import 'package:my_pesa/errors.dart';
import 'package:my_pesa/export/export_cubit.dart';
import 'package:my_pesa/export/export_state.dart';

import '../helpers/sheets_repository.dart';

MockSheetRepository mockSheetsRepository = MockSheetRepository();
void main() {
  group('ExportCubit', () {
    test('check state equality ', () {
      expect(ExportCubit(sheetRepository: mockSheetsRepository).state,
          ExportCubit(sheetRepository: mockSheetsRepository).state);
    });

    blocTest<ExportCubit, ExportState>(
      'emits [themeMode: ThemeMode.dark] when setThemeMode',
      build: () => ExportCubit(sheetRepository: mockSheetsRepository),
      act: (cubit) => cubit.exportToGoogleSheets([], [], ExportType.single),
      expect: () => [ExportState(error: noTransactionsError)],
    );
  });
}
