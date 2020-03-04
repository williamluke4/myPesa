
import 'package:myPesa/models/Transaction.dart';

class Account {
  List<Transaction> transactions = <Transaction>[];
  String name;
  String balance;
  void addTransaction(Transaction tx) => transactions.add(tx);

  void sortTransactions(){
    transactions.sort((a,b) {
      if(b.dateTime != null && a.dateTime != null){
        return b.dateTime.compareTo(a.dateTime);
      }
      else {

        return 0;
      }
    });
    balance = transactions[0].balance;
  }
  Account(this.name);
}