


import 'package:flutter/material.dart';
import 'package:myPesa/models/Account.dart';

class BalanceWidget  extends StatelessWidget {
  final Account account;
  Widget build(BuildContext context){
  return  new Container(
    height: 130,
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        color: Colors.green,
        elevation: 10,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment
                    .centerLeft, // Align however you like (i.e .centerRight, centerLeft)
                child: Text("Balance",
                    textScaleFactor: 2,
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment
                    .center, // Align however you like (i.e .centerRight, centerLeft)
                child: Text("Ksh ${this.account.balance}",
                    textAlign: TextAlign.center,
                    textScaleFactor: 3,
                    style: TextStyle(color: Colors.white, shadows: [
                      Shadow(blurRadius: 5, color: Colors.grey),
                      Shadow(blurRadius: 4, color: Colors.green)
                    ])),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  }
  BalanceWidget(this.account);
}

