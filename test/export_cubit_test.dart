import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/cubits/export/export_cubit.dart';
import 'package:my_pesa/cubits/export/export_state.dart';
import 'package:my_pesa/errors.dart';

import 'helpers/sheets_repository.dart';

MockSheetRepository mockSheetsRepository = MockSheetRepository();
MockGoogleSignInAccount mockUser = MockGoogleSignInAccount();

void main() {
  group('ExportCubit', () {
    test('check state equality ', () {
      expect(
        ExportCubit(sheetRepository: mockSheetsRepository).state,
        ExportCubit(sheetRepository: mockSheetsRepository).state,
      );
    });

    blocTest<ExportCubit, ExportState>(
      'emits [error: noTransactionsError] when there are no transactions',
      build: () => ExportCubit(sheetRepository: mockSheetsRepository),
      act: (cubit) => cubit.exportToGoogleSheets(mockUser, [], []),
      expect: () => [
        const ExportState(isLoading: true),
        ExportState(error: noTransactionsError)
      ],
    );
  });
}
