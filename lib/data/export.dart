import 'package:googleapis/sheets/v4.dart';
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

enum ExportType { split, single }

List<RowData> exportTransaction(Transaction tx, ExportType type) {
  switch (type) {
    case ExportType.split:
      return [
        RowData(
          values: [
            cell(stringValue: tx.date),
            cell(stringValue: tx.ref),
            cell(stringValue: tx.recipient),
            cell(stringValue: '${txTypeToString(tx)}${tx.amount}'),
            cell(stringValue: tx.categoryId),
            cell(stringValue: tx.balance),
            if (tx.type == TransactionType.UNKNOWN) cell(stringValue: tx.body)
          ],
        ),
        if (tx.txCost.isNotEmpty && tx.txCost != '0.00')
          RowData(
            values: [
              cell(stringValue: tx.date),
              cell(stringValue: tx.ref),
              cell(stringValue: 'MPESA Transaction Fee'),
              cell(stringValue: '-${tx.txCost}'),
              cell(stringValue: tx.categoryId),
              cell(stringValue: tx.balance),
              if (tx.type == TransactionType.UNKNOWN) cell(stringValue: tx.body)
            ],
          )
      ];
    case ExportType.single:
      return [
        RowData(
          values: [
            cell(stringValue: tx.date),
            cell(stringValue: tx.ref),
            cell(stringValue: tx.recipient),
            cell(stringValue: '${txTypeToString(tx)}${tx.amount}'),
            cell(stringValue: tx.txCost),
            cell(stringValue: tx.categoryId),
            cell(stringValue: tx.balance),
            if (tx.type == TransactionType.UNKNOWN) cell(stringValue: tx.body)
          ],
        )
      ];
  }
}
