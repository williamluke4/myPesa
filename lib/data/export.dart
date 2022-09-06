import 'package:googleapis/sheets/v4.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';

CellData cell({String? stringValue}) {
  return CellData(
    userEnteredValue: ExtendedValue(stringValue: stringValue),
  );
}

String txTypeToString(Transaction tx) {
  switch (tx.type) {
    case TransactionType.IN:
      return '';
    case TransactionType.OUT:
      return '-';
    case TransactionType.UNKNOWN:
      return '?';
  }
}

class SheetHeaders {
  String get recipient => 'recipient';
  String get ref => 'ref';
  String get amount => 'amount';
  String get txCost => 'txCost';
  String get balance => 'balance';
  String get notes => 'notes';
  String get type => 'type';
  String get categoryId => 'categoryId';
  String get body => 'body';
  String get dateTime => 'dateTime';
}

final List<String> transactionHeaders = [
  'Date',
  'Ref',
  'Recipient',
  'In',
  'Out',
  'TxFee',
  'Category',
  'Balance',
  'Notes'
];
RowData sheetHeaders = RowData(
  values: transactionHeaders
      .map<CellData>((header) => cell(stringValue: header))
      .toList(),
);

List<RowData> exportTransaction(Transaction tx, List<Category> categories) {
  Category getCategoryById(String categoryId) {
    return categories.firstWhere((element) => element.id == categoryId);
  }

  return [
    RowData(
      values: [
        cell(stringValue: tx.date),
        cell(stringValue: tx.ref),
        cell(stringValue: tx.recipient),
        // In
        cell(stringValue: tx.type == TransactionType.IN ? tx.amount : ''),
        // Out
        cell(stringValue: tx.type == TransactionType.OUT ? tx.amount : ''),
        cell(stringValue: tx.txCost),
        cell(stringValue: getCategoryById(tx.categoryId).name),
        cell(stringValue: tx.balance),
        cell(stringValue: tx.notes),
        if (tx.type == TransactionType.UNKNOWN) cell(stringValue: tx.body)
      ],
    )
  ];
}
