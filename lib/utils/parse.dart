import 'package:basic_utils/basic_utils.dart';
import 'package:intl/intl.dart';
import 'package:myPesa/models/Account.dart';
import 'package:myPesa/models/Transaction.dart';
import 'package:safe_sms/sms.dart';

RegExp getBalanceRX = new RegExp(r"balance\s+(is|was)\s+([a-zA-Z]+)([\d,]+.\d{2})");
RegExp getTXCostRX = new RegExp(r"Transaction\s*cost,\s*([a-zA-Z]+)([\d.,]+)\.");
RegExp getLipaOrSendRX = new RegExp(r"([a-zA-Z]+)([\d.,]+)\s*(paid to|sent to| of)\s+(.+?)(?=\son\s)");
RegExp getDateAndTime = new RegExp(r"on\s*([\d]{1,2}[\/][\d]{1,2}[\/][\d]{1,2})\s*at\s*(\d{1,2}:\d{2} [A-Z]{2})");
RegExp getRef = new RegExp(r"([A-Z0-9]{10})");
RegExp getReceived = new RegExp(r"received\s+([a-zA-Z]+)([\d.,]+)\s*(from)\s+(.*?)\.{0,1}on");
RegExp getWithdraw = new RegExp(r"Withdraw\s+([a-zA-Z]+)([\d.,]+)\s*(from)\s+(.*?)\.{0,1}on");



Transaction getMpesaTransaction(String body){
  var txCost;
  var ref;
  var recipient;
  var amount;
  var type;
  var balance;
  var dateTime;

  Match balanceMatch = getBalanceRX.firstMatch(body);
  if(balanceMatch != null){
    balance =   balanceMatch.group(3);
  }
  Match txCostMatch = getTXCostRX.firstMatch(body);
  if(txCostMatch != null){
    txCost =   txCostMatch.group(2);
  }
  Match refMatch = getRef.firstMatch(body);
  if(refMatch != null){
    ref = refMatch.group(1);
  }
  Match getDateAndTimeMatch = getDateAndTime.firstMatch(body);

  if(getDateAndTimeMatch != null){
    String date  = StringUtils.addCharAtPosition(getDateAndTimeMatch.group(1), "20", getDateAndTimeMatch.group(1).length-2);
    String time =   getDateAndTimeMatch.group(2);
    dateTime =  new DateFormat("dd/MM/yyyy h:mm a").parse(date + ' ' + time);
  }
  Match getLipaOrSendMatch = getLipaOrSendRX.firstMatch(body);
  if(getLipaOrSendMatch != null){
    type = TransactionType.OUT;
    amount =   getLipaOrSendMatch.group(2);
    recipient =   getLipaOrSendMatch.group(4);
  }
  Match getReceivedMatch = getReceived.firstMatch(body);
  if(getReceivedMatch != null){
    type = TransactionType.IN;
    amount =   getReceivedMatch.group(2);
    recipient =   getReceivedMatch.group(4);
  }
  Match getWithdrawMatch = getWithdraw.firstMatch(body);
  if(getWithdrawMatch != null){
    type = TransactionType.OUT;
    amount =   getWithdrawMatch.group(2);
    recipient =   getWithdrawMatch.group(4);
  }
  var tx = new Transaction(recipient,ref, amount, txCost, balance, type, dateTime, body);

  return tx;
}



void parseTransactions(SmsMessage message, Account account) {
  if (message.sender == "MPESA") {
    {
      Transaction tx = getMpesaTransaction(message.body);
      if (tx != null && tx.amount != null) account.addTransaction(tx);
    } //print(message.body);
  }
}
DateFormat dateFormat = DateFormat("dd-MM-yyyy");
String dateTimeToDate(DateTime date){
  return dateFormat.format(date);

}