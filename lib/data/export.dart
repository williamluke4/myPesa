import 'package:googleapis/sheets/v4.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/utils/datetime.dart';

CellData cell({
  String? stringValue,
  bool? boolValue,
  ErrorValue? errorValue,
  String? formulaValue,
  double? numberValue,
}) {
  return CellData(
    userEnteredValue: ExtendedValue(
      stringValue: stringValue,
      boolValue: boolValue,
      errorValue: errorValue,
      formulaValue: formulaValue,
      numberValue: numberValue,
    ),
  );
}

CellData currencyCell({
  double? value,
}) {
  return CellData(
    userEnteredValue: ExtendedValue(
      numberValue: value,
    ),
  );
}

CellData dateTimeCell({
  DateTime? value,
}) {
  return CellData(
    userEnteredValue: ExtendedValue(
      numberValue: dateToGsheets(value),
    ),
    userEnteredFormat: CellFormat(
      numberFormat: NumberFormat(
        type: 'DATE_TIME',
      ),
    ),
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
final List<String> splitTransactionHeaders = [
  'Date',
  'Ref',
  'Recipient',
  'Amount',
  'Category',
  'Notes',
];

RowData getSheetHeaders({required bool separateTransactionFees}) {
  if (separateTransactionFees) {
    return RowData(
      values: splitTransactionHeaders
          .map<CellData>((header) => cell(stringValue: header))
          .toList(),
    );
  }
  return RowData(
    values: transactionHeaders
        .map<CellData>((header) => cell(stringValue: header))
        .toList(),
  );
}

List<RowData> exportTransaction({
  required Transaction tx,
  required List<Category> categories,
  required bool debugMode,
  required bool separateTransactionFees,
}) {
  Category getCategoryById(String categoryId) {
    return categories.firstWhere((element) => element.id == categoryId);
  }

  final amount = double.tryParse(tx.amount.replaceAll(',', ''));
  final txCost = double.tryParse(tx.txCost.replaceAll(',', ''));
  final balance = double.tryParse(tx.balance.replaceAll(',', ''));
  if (separateTransactionFees) {
    final feeCategory = Category.fee();
    return [
      RowData(
        values: [
          // Date
          dateTimeCell(value: tx.dateTime),
          // Ref
          cell(stringValue: tx.ref),
          // Recipient
          cell(stringValue: tx.recipient),
          // Amount
          currencyCell(value: txCost == null ? null : txCost * -1),
          // Category
          cell(stringValue: feeCategory.name),
        ],
      ),
      RowData(
        values: [
          // Date
          dateTimeCell(value: tx.dateTime),
          // Ref
          cell(stringValue: tx.ref),
          // Recipient
          cell(stringValue: tx.recipient),
          // Amount
          currencyCell(value: tx.getSignedAmount),
          // Category
          cell(stringValue: getCategoryById(tx.categoryId).name),
          // Notes
          cell(stringValue: tx.notes),
          // Debug (Body)
          if (debugMode || tx.type == TransactionType.UNKNOWN)
            cell(stringValue: tx.body)
        ],
      )
    ];
  } else {
    return [
      RowData(
        values: [
          // Date
          dateTimeCell(value: tx.dateTime),
          // Ref
          cell(stringValue: tx.ref),
          // Recipient
          cell(stringValue: tx.recipient),
          // In
          currencyCell(value: tx.type == TransactionType.IN ? amount : null),
          // Out
          currencyCell(value: tx.type == TransactionType.OUT ? amount : null),
          // TX Cost
          currencyCell(value: txCost),
          // Category
          cell(stringValue: getCategoryById(tx.categoryId).name),
          // Balance
          currencyCell(value: balance),
          // Notes
          cell(stringValue: tx.notes),
          // Debug (Body)
          if (debugMode || tx.type == TransactionType.UNKNOWN)
            cell(stringValue: tx.body)
        ],
      )
    ];
  }
}
