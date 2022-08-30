import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_pesa/data/export.dart';
import 'package:my_pesa/data/models/category.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/utils/logger.dart';

DateFormat dateFormat = DateFormat('MMMM yyyy');

String dateTimeToString(DateTime date) {
  return dateFormat.format(date);
}

class SheetRepository {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  SheetRepository({required this.user});

  final GoogleSignInAccount user;

  Future<void> getTransactionsFromSheet({
    required String spreadsheetId,
  }) async {
    final sheetsAPI = await getAPI();
    final sheet =
        await sheetsAPI.spreadsheets.get(spreadsheetId, includeGridData: true);
    final data = sheet.sheets![0].data;
    // final transactions = <Transaction>[];
    sheet.sheets?.forEach((element) {
      final gridDataList = element.data;
      gridDataList?.forEach((gridData) {
        final rowDataList = gridData.rowData;
        rowDataList?.forEach((rowData) {
          final rowValues = <String>[];
          rowData.values?.forEach((element) {
            rowValues.add(element.effectiveValue?.stringValue ?? '');
          });
          log.d(rowValues);
          // try {
          //   final transaction = Transaction.fromRow(rowValues);
          //   transactons.add(transaction);
          // } catch (e) {
          //   logger.e(e);
          // }
          // enteries.add(rowValues);
        });
      });
    });

    log.d(data);

    final rowData = data != null ? data[0].rowData : <RowData>[];
    log.d(rowData);
  }

  Future<SheetsApi> getAPI() async {
    final authHeaders = await user.authHeaders;
    final sheetsAPI = SheetsApi(AuthClient(authHeaders, http.Client()));
    return sheetsAPI;
  }

  Future<Spreadsheet?> createSheet({
    required List<Transaction> transactions,
    required List<Category> categories,
  }) async {
    final sheetsAPI = await getAPI();
    try {
      final rowData = transactions.fold<List<RowData>>([], (value, tx) {
        value.addAll(exportTransaction(tx, categories));
        return value;
      });
      final sheet = Sheet(
        properties: SheetProperties(title: 'Transactions'),
        data: [
          GridData(
            rowData: rowData.toList().reversed.toList()
              ..insert(0, sheetHeaders),
          )
        ],
      );

      final spreadsheet = await sheetsAPI.spreadsheets.create(
        Spreadsheet(
          properties: SpreadsheetProperties(title: 'myPesa'),
          sheets: [sheet],
        ),
      );
      return spreadsheet;
    } catch (e) {
      log.e(e.toString());
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
