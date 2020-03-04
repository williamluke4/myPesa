import 'package:safe_sms/sms.dart';
import 'package:myPesa/models/Account.dart';
import 'package:myPesa/utils/parse.dart';

Future  getAccountFromMessages() async {
  Account account = new Account("MPESA");
  SmsQuery query = new SmsQuery();
  List<SmsMessage> mpesaMessages = await query.querySms(
    address: account.name
  );
  mpesaMessages.forEach((message) => parseTransactions(message, account));
  account.sortTransactions();

  return account;
}