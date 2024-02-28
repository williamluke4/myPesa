import 'package:mocktail/mocktail.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/data/transactions_repository.dart';

String sentTransactionMessage =
    '''QC352PDIVL Confirmed. Ksh1,000.00 sent to SOPHIA  MWENI 0702972812 on 3/3/22 at 5:28 PM. New M-PESA balance is Ksh25,203.19. Transaction cost, Ksh12.00. Amount you can transact within the day is 292,600.00. Send KES100 & below to POCHI LA BIASHARA for FREE! To reverse, foward this message to 456.''';

final mockCategories = [Category(name: 'Unknown'), Category(name: 'Groceries')];

Transaction sentTransaction = Transaction(
  recipient: 'SOPHIA  MWENI 0702972812',
  ref: 'QC352PDIVL',
  amount: '1,000.00',
  txCost: '12.00',
  balance: '25,203.19',
  type: TransactionType.OUT,
  body: sentTransactionMessage,
  categoryId: mockCategories[0].id,
  dateTime: DateTime(2022, 3, 3, 17, 28),
);

String sentTransactionWrongTimeFormatMessage =
    '''PAG5ONUZYT Confirmed. Ksh1,600.00 sent to 0780603578 on 16/1/21 at 5:9 PM. New M-PESA balance is Ksh226.85. Transaction cost, Ksh74.00. To reverse, forward this message to 456.''';
Transaction sentTransactionWrongTimeFormat = Transaction(
  recipient: '0780603578',
  ref: 'PAG5ONUZYT',
  amount: '1,600.00',
  txCost: '74.00',
  balance: '226.85',
  type: TransactionType.OUT,
  categoryId: mockCategories[0].id,
  body: sentTransactionWrongTimeFormatMessage,
  dateTime: DateTime(2021, 1, 16, 17, 9),
);

// String reversedTransactionMessage =
//     '''OAV2QRV4K4  Confirmed. Transaction OAO4LC1T3S has 
// been reversed.  Your account balance is now Ksh12,260.03.''';
String reversedTransactionMessage =
    '''SBN3Y4FTKV confirmed. Reversal of transaction SBN0XW46IM has been successfully reversed  on 23/2/24  at 5:37 PM and Ksh10.00 is credited to your M-PESA account. New M-PESA account balance is Ksh21,207.92.''';
Transaction reversedTransaction = Transaction(
  recipient: 'Reversal of SBN0XW46IM',
  ref: 'SBN3Y4FTKV',
  amount: '10.00',
  balance: '21,207.92',
  type: TransactionType.IN,
  body: reversedTransactionMessage,
  categoryId: mockCategories[0].id,
  dateTime: DateTime(2024, 2, 23, 17, 37),
);
String depositTransactionMessage =
    '''PK95FQHDN1 Confirmed. On 9/11/21 at 7:07 PM Give Ksh60,000.00 cash to Naivas Supermarket Kilifi New M-PESA balance is Ksh104,061.96. You can now access M-PESA via *334#''';

Transaction depositTransaction = Transaction(
  recipient: 'Naivas Supermarket Kilifi',
  ref: 'QC352PDIVL',
  amount: '60,000.00',
  balance: '104,061.96',
  type: TransactionType.IN,
  body: depositTransactionMessage,
  categoryId: mockCategories[0].id,
  dateTime: DateTime(2021, 11, 9, 19, 7),
);

final mockTransactions = [
  sentTransaction,
  sentTransactionWrongTimeFormat,
  depositTransaction,
];

class MockTransactionsRepository extends Mock
    implements TransactionsRepository {
  @override
  Future<List<Transaction>> getTxsFromSMS() async {
    return mockTransactions;
  }
}
