import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/transaction.dart';

DateFormat dateFormat = DateFormat('MMMM yyyy');

String dateTimeToString(DateTime date) {
  return dateFormat.format(date);
}

class SheetRepository {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  SheetRepository({required this.authHeaders})
      : sheetsAPI = SheetsApi(AuthClient(authHeaders, http.Client()));

  final SheetsApi sheetsAPI;
  final Map<String, String> authHeaders;

  Future<Spreadsheet?> createSheet({
    required List<Transaction> transactions,
  }) async {
    try {
      final monthYearTransactions = groupBy<Transaction, String>(
        transactions,
        (tx) =>
            tx.dateTime != null ? dateTimeToString(tx.dateTime!) : 'Unknown',
      );

      final sheets = monthYearTransactions.keys.map((date) {
        final txs = monthYearTransactions[date];
        final rowData = txs?.map((tx) {
          // TODO(williamluke4): Clean this up.
          return RowData(
            values: [
              CellData(
                userEnteredValue: ExtendedValue(stringValue: tx.date),
              ),
              CellData(
                userEnteredValue: ExtendedValue(stringValue: tx.ref),
              ),
              CellData(
                userEnteredValue: ExtendedValue(stringValue: tx.recipient),
              ),
              CellData(
                userEnteredValue: ExtendedValue(
                  stringValue: '${txTypeToString(tx)}${tx.amount}',
                ),
              ),
              CellData(
                userEnteredValue: ExtendedValue(stringValue: tx.txCost),
              ),
              CellData(
                userEnteredValue: ExtendedValue(stringValue: tx.balance),
              )
            ],
          );
        });

        return Sheet(
          properties: SheetProperties(title: date),
          data: [
            GridData(
              rowData: rowData?.toList().reversed.toList() ?? <RowData>[],
            )
          ],
        );
      });

      final spreadsheet = await sheetsAPI.spreadsheets.create(
        Spreadsheet(
          properties: SpreadsheetProperties(title: 'mPesa Transactions'),
          sheets: sheets.toList(),
        ),
      );
      return spreadsheet;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
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

class AuthClient extends http.BaseClient {
  AuthClient(this.authHeaders, this._inner);
  final http.Client _inner;
  final Map<String, String> authHeaders;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(authHeaders);
    return _inner.send(request);
  }
}
