import 'package:safe_sms/sms.dart';
import 'package:myPesa/models/Account.dart';
import 'package:myPesa/utils/parse.dart';
import 'dart:async';

Future  getAccountFromMessages() async {
  Account account = new Account("MPESA");
  SmsQuery query = new SmsQuery();
  try {
    List<SmsMessage> mpesaMessages = await query.querySms(
      address: account.name
    ).timeout(const Duration(seconds: 3));
    mpesaMessages.forEach((message) => parseTransactions(message, account));
    account.sortTransactions();

  } on TimeoutException catch (e) {
    print('Timeout');
    return null;
  } on Error catch (e) {
    print('Error: $e');
    return null;
  }
  return account;
}