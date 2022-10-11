import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/cubits/database/database_cubit.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/errors.dart';

import 'helpers/hydrated_bloc.dart';
import 'helpers/mocks.dart';

final txRepo = MockTransactionsRepository();
Future<DatabaseCubit> buildDatabaseCubit() async => await mockHydratedStorage(
      () => DatabaseCubit(transactionsRepository: txRepo),
    );
void main() {
  group('generic', () {
    test('equality', () async {
      final cubit1 = await buildDatabaseCubit();
      final cubit2 = await buildDatabaseCubit();
      expect(
        cubit1.state,
        cubit2.state,
      );
    });
    test('hydration', () async {
      final cubit1 = await buildDatabaseCubit();
      await cubit1.fetchTransactionsFromSMS();
      await cubit1.addCategory('Test', '');
      await cubit1.addCategory('Test', '🤔');
      expect(
        cubit1.state.transactions,
        mockTransactions,
      );
      final json = cubit1.toJson(cubit1.state);
      final fromJson = cubit1.fromJson(json!);
      expect(
        cubit1.state,
        fromJson,
      );
      //
    });
    test('import/export', () async {
      final cubit1 = await buildDatabaseCubit();
      final cubit2 = await buildDatabaseCubit();

      await cubit1.fetchTransactionsFromSMS();
      await cubit1.fetchTransactionsFromSMS();

      await cubit1.addCategory('Test', '');
      await cubit1.addCategory('Test', '🤔');
      expect(
        cubit1.state.transactions,
        mockTransactions,
      );

      final json = cubit1.toJson(cubit1.state);
      final state = cubit2.fromJson(json!);
      expect(
        cubit1.state,
        state,
      );
      //
    });
  });
  group('transactions', () {
    late DatabaseCubit cubit;
    setUp(() async {
      cubit = await buildDatabaseCubit();
    });
    blocTest<DatabaseCubit, DatabaseState>(
      'loads transactions',
      build: () => cubit,
      act: (cubit) {
        cubit.fetchTransactionsFromSMS();
      },
      expect: () => [cubit.state.copyWith(transactions: mockTransactions)],
    );
  });
  group('categories', () {
    test('unable to delete default', () async {
      final cubit1 = await buildDatabaseCubit();
      await cubit1.deleteCategory(Category.none());
      expect(
        cubit1.state,
        cubit1.state.copyWith(error: notAllowedToDeleteError),
      );
    });
    test('crud', () async {
      final cubit1 = await buildDatabaseCubit();
      // Add
      final c1 = await cubit1.addCategory('Test', '');
      final c2 = await cubit1.addCategory('Test 2', '🤔');
      var expectedCategories = [...defaultCategories, c1!, c2!]
        ..sort((a, b) => a.name.compareTo(b.name));
      expect(
        cubit1.state,
        cubit1.state.copyWith(
          categories: expectedCategories,
        ),
      );

      // Delete
      await cubit1.deleteCategory(c1);
      expectedCategories = [...defaultCategories, c2]
        ..sort((a, b) => a.name.compareTo(b.name));

      expect(
        cubit1.state,
        cubit1.state.copyWith(
          categories: expectedCategories,
        ),
      );
      // Update
      await cubit1.updateCategory(c2.id, c2.copyWith(name: 'Test 🤔🤔'));
      expect(
        cubit1.findCategory(c2.id)?.name,
        'Test 🤔🤔',
      );

      final json = cubit1.toJson(cubit1.state);
      final state = cubit1.fromJson(json!);
      expect(cubit1.state, state);
    });
  });
}
