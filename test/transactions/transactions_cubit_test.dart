import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/transactions/transactions_cubit.dart';

import '../helpers/hydrated_bloc.dart';
import '../helpers/mocks.dart';

void main() {
  final txRepo = MockTransactionsRepository();
  group('TransactionsCubit', () {
    late TransactionsCubit accountCubit1;
    late TransactionsCubit accountCubit2;

    setUp(() async {
      accountCubit1 = await mockHydratedStorage(
        () => TransactionsCubit(transactionsRepository: txRepo),
      );
      accountCubit2 = await mockHydratedStorage(
        () => TransactionsCubit(transactionsRepository: txRepo),
      );
    });
    test('equality', () async {
      expect(
        accountCubit1.state,
        accountCubit2.state,
      );
    });
    test('hydration', () async {
      await accountCubit1.refreshTransactions(test: true);
      expect(
        accountCubit1.state.transactions,
        mockTransactions,
      );
      final json = accountCubit1.toJson(accountCubit1.state);
      final state = accountCubit2.fromJson(json!);
      expect(
        state,
        accountCubit1.state,
      );
    });
    group('operations', () {
      late TransactionsCubit accountCubit;
      setUp(() async {
        accountCubit = await mockHydratedStorage(
          () => TransactionsCubit(transactionsRepository: txRepo),
        );
      });
      blocTest<TransactionsCubit, TransactionsState>(
        'loads transactions',
        build: () => accountCubit,
        act: (cubit) {
          cubit.refreshTransactions(test: true);
        },
        expect: () => [TransactionsState(transactions: mockTransactions)],
      );
    });
  });
}
