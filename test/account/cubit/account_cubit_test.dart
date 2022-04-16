import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/account/account.dart';

void main() {
  group('AccountCubit', () {
    test('initial state is ', () {
      expect(AccountCubit().state, equals(0));
    });

    blocTest<AccountCubit, AccountState>(
      'emits [1] when increment is called',
      build: AccountCubit.new,
      act: (cubit) => cubit.loadAccount(),
      expect: () => [equals(1)],
    );

    blocTest<AccountCubit, AccountState>(
      'emits [-1] when decrement is called',
      build: AccountCubit.new,
      act: (cubit) => cubit.loadAccount(),
      expect: () => [equals(-1)],
    );
  });
}
