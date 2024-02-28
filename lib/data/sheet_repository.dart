import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multiple_result/multiple_result.dart';
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
  SheetRepository();

  Future<SheetsApi> getAPI(GoogleSignInAccount user) async {
    final authHeaders = await user.authHeaders;
    final sheetsAPI = SheetsApi(AuthClient(authHeaders, http.Client()));
    return sheetsAPI;
  }

  Future<Result<Spreadsheet, Exception>> createSheet({
    required GoogleSignInAccount user,
    required List<Transaction> transactions,
    required List<Category> categories,
    required bool separateTransactionFees,
    required bool debugMode,
  }) async {
    final sheetsAPI = await getAPI(user);
    try {
      final rowData = transactions.fold<List<RowData>>([], (value, tx) {
        value.addAll(exportTransaction(
          tx: tx,
          categories: categories,
          debugMode: debugMode,
          separateTransactionFees: separateTransactionFees,
        ),);
        return value;
      });
      final sheet = Sheet(
        properties: SheetProperties(title: 'Transactions'),
        data: [
          GridData(
            rowData: rowData.toList().reversed.toList()
              ..insert(
                0,
                getSheetHeaders(
                  separateTransactionFees: separateTransactionFees,
                ),
              ),
          ),
        ],
      );
      final now = DateTime.now();
      final formatter = DateFormat('yyyy-MM-dd');
      final formattedDate = formatter.format(now);

      final spreadsheet = await sheetsAPI.spreadsheets.create(
        Spreadsheet(
          properties:
              SpreadsheetProperties(title: 'myPesa-export-$formattedDate'),
          sheets: [sheet],
        ),
      );
      return Success(spreadsheet);
    } catch (e) {
      log.e(e.toString());
      return Error(Exception(e));
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
