import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/intl.dart';
import 'package:my_pesa/data/models/transaction.dart';

RegExp getBalanceRX = RegExp(r'balance\s+(is|was)\s+([a-zA-Z]+)([\d,]+.\d{2})');
RegExp getTXCostRX = RegExp(r'Transaction\s*cost,\s*([a-zA-Z]+)([\d.,]+)\.');
RegExp getLipaOrSendRX =
    RegExp(r'([a-zA-Z]+)([\d.,]+)\s*(paid to|sent to| of)\s+(.+?)(?=\son\s)');
RegExp getDateAndTime = RegExp(
  r'on\s*([\d]{1,2}[\/][\d]{1,2}[\/][\d]{1,2})\s*at\s*(\d{1,2}:\d{1,2} [A-Z]{2})',
  caseSensitive: false,
);
RegExp getRef = RegExp('([A-Z0-9]{10})');
RegExp getReceived = RegExp(
  r'received\s+([a-zA-Z]+)([\d.,]+)\s*(from)\s+(.*?)\.{0,1}on',
  caseSensitive: false,
);
RegExp getWithdraw =
    RegExp(r'Withdraw\s+([a-zA-Z]+)([\d.,]+)\s*(from)\s+(.*?)\.{0,1}on');
RegExp getDeposit = RegExp(r'Give Ksh([\d.,]+) cash to (.+) New');

Transaction? parseMpesaTransaction(String body) {
  String? txCost;
  String? ref;
  String? recipient;
  String? amount;
  TransactionType? type;
  String? balance;
  DateTime? dateTime;
  final Match? balanceMatch = getBalanceRX.firstMatch(body);
  if (balanceMatch != null) {
    balance = balanceMatch.group(3);
  }
  final Match? txCostMatch = getTXCostRX.firstMatch(body);
  if (txCostMatch != null) {
    txCost = txCostMatch.group(2);
  }
  final Match? refMatch = getRef.firstMatch(body);
  if (refMatch != null) {
    ref = refMatch.group(1);
  }
  final Match? getDateAndTimeMatch = getDateAndTime.firstMatch(body);
  if (getDateAndTimeMatch != null) {
    final date = StringUtils.addCharAtPosition(
      getDateAndTimeMatch.group(1)!,
      '20',
      getDateAndTimeMatch.group(1)!.length - 2,
    );
    final time = getDateAndTimeMatch.group(2)!;
    dateTime = DateFormat('dd/MM/yyyy h:mm a').parse('$date $time');
  }
  final Match? getLipaOrSendMatch = getLipaOrSendRX.firstMatch(body);
  if (getLipaOrSendMatch != null) {
    type = TransactionType.OUT;
    amount = getLipaOrSendMatch.group(2);
    recipient = getLipaOrSendMatch.group(4);
  }
  final Match? getReceivedMatch = getReceived.firstMatch(body);
  if (getReceivedMatch != null) {
    type = TransactionType.IN;
    amount = getReceivedMatch.group(2);
    recipient = getReceivedMatch.group(4);
  }
  final Match? getWithdrawMatch = getWithdraw.firstMatch(body);
  if (getWithdrawMatch != null) {
    type = TransactionType.OUT;
    amount = getWithdrawMatch.group(2);
    recipient = getWithdrawMatch.group(4);
  }
  final Match? getDepositMatch = getDeposit.firstMatch(body);
  if (getDepositMatch != null) {
    type = TransactionType.IN;
    amount = getDepositMatch.group(1);
    recipient = getDepositMatch.group(2);
  }
  if (ref == null) {
    return null;
  }
  return Transaction(
    recipient: recipient ?? '',
    ref: ref,
    amount: amount ?? '',
    txCost: txCost ?? '',
    balance: balance ?? '',
    type: type ?? TransactionType.UNKNOWN,
    dateTime: dateTime,
    body: body,
  );
}

Transaction? parseTransaction(SmsMessage message) {
  if (message.sender == 'MPESA' && message.body != null) {
    final transaction = parseMpesaTransaction(message.body ?? '');
    return transaction;
  }
  return null;
}

DateFormat dateFormat = DateFormat('dd-MM-yyyy');

String dateTimeToString(DateTime date) {
  return dateFormat.format(date);
}
