import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_pesa/categories/categories_cubit.dart';
import 'package:my_pesa/data/export.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';

DateFormat dateFormat = DateFormat('MMMM yyyy');

String dateTimeToString(DateTime date) {
  return dateFormat.format(date);
}

class SheetRepository {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  SheetRepository({required this.user});

  final GoogleSignInAccount user;

  Future<Spreadsheet?> createSheet({
    required List<Transaction> transactions,
    required List<Category> categories,
    required ExportType type,
  }) async {
    final authHeaders = await user.authHeaders;
    final sheetsAPI = SheetsApi(AuthClient(authHeaders, http.Client()));
    try {
      final monthYearTransactions = groupBy<Transaction, String>(
        transactions,
        (tx) =>
            tx.dateTime != null ? dateTimeToString(tx.dateTime!) : 'Unknown',
      );

      final sheets = monthYearTransactions.keys.map((date) {
        final txs = monthYearTransactions[date];
        final rowData = txs?.fold<List<RowData>>([], (value, tx) {
          value.addAll(exportTransaction(tx,categories, type));
          return value;
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
