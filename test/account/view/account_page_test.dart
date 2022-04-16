import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_pesa/account/account.dart';

import '../../helpers/helpers.dart';

class MockAccountCubit extends MockCubit<AccountState> implements AccountCubit {
}

void main() {
  group('AccountPage', () {
    testWidgets('renders AccountView', (tester) async {
      await tester.pumpApp(const AccountPage());
      expect(find.byType(AccountView), findsOneWidget);
    });
  });

  group('AccountView', () {
    late AccountCubit accountCubit;

    setUp(() {
      accountCubit = MockAccountCubit();
    });

    testWidgets('renders current count', (tester) async {
      final state = AccountInitial();
      when(() => accountCubit.state).thenReturn(state);
      await tester.pumpApp(
        BlocProvider.value(
          value: accountCubit,
          child: const AccountView(),
        ),
      );
      expect(find.text('$state'), findsOneWidget);
    });

    // testWidgets('calls increment when increment button is tapped',
    //     (tester) async {
    //   when(() => counterCubit.state).thenReturn(0);
    //   when(() => counterCubit.increment()).thenReturn(null);
    //   await tester.pumpApp(
    //     BlocProvider.value(
    //       value: counterCubit,
    //       child: const CounterView(),
    //     ),
    //   );
    //   await tester.tap(find.byIcon(Icons.add));
    //   verify(() => counterCubit.increment()).called(1);
    // });

    // testWidgets('calls decrement when decrement button is tapped',
    //     (tester) async {
    //   when(() => counterCubit.state).thenReturn(0);
    //   when(() => counterCubit.decrement()).thenReturn(null);
    //   await tester.pumpApp(
    //     BlocProvider.value(
    //       value: counterCubit,
    //       child: const CounterView(),
    //     ),
    //   );
    //   await tester.tap(find.byIcon(Icons.remove));
    //   verify(() => counterCubit.decrement()).called(1);
    // });
  });
}
