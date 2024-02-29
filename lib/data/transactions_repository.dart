import 'package:carrier_info/carrier_info.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:my_pesa/data/models/transaction.dart';
import 'package:my_pesa/utils/logger.dart';
import 'package:my_pesa/utils/parse/mpesa.dart';
import 'package:permission_handler/permission_handler.dart';

enum TransactionProvider {
  mpesa('MPESA');

  const TransactionProvider(this.value);
  final String value;
}

class TransactionsRepository {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  TransactionsRepository();

  Future<List<Transaction>> getTxsFromSMS() async {
    await [
      Permission.locationWhenInUse,
      Permission.phone,
      Permission.sms,
    ].request();

    AndroidCarrierData? carrierInfo;
    try {
      carrierInfo = await CarrierInfo.getAndroidInfo();
    } catch (error) {
      log.e('Failed to Get CarrierInfo', [error]);
    }

    final query = SmsQuery();
    final transactions = <Transaction>[];
    final messages = await query.querySms(
      address: TransactionProvider.mpesa.value,
      sort: true,
      kinds: [SmsQueryKind.inbox],
    );
    for (final message in messages) {
      final transaction = parseTransaction(message, carrierInfo);
      if (transaction != null) {
        transactions.add(transaction);
      }
    }
    sortTransactions(transactions);
    return transactions;
  }

  void sortTransactions(List<Transaction> transactions) {
    transactions.sort((a, b) {
      if (b.dateTime != null && a.dateTime != null) {
        return b.dateTime!.compareTo(a.dateTime!);
      } else {
        return 0;
      }
    });
  }
}
