import 'package:flutter/material.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({Key? key, required this.balance}) : super(key: key);
  final String balance;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          color: Colors.green,
          elevation: 10,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment
                      .centerLeft, // Align however you like (i.e .centerRight, centerLeft)
                  child: Text(
                    "Balance",
                    textScaleFactor: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment
                      .center, // Align however you like (i.e .centerRight, centerLeft)
                  child: Text(
                    "Ksh $balance",
                    textAlign: TextAlign.center,
                    textScaleFactor: 3,
                    style: const TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 5, color: Colors.grey),
                        Shadow(blurRadius: 4, color: Colors.green)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
