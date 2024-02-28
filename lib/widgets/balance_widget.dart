import 'package:flutter/material.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key, required this.balance});
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
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Balance',
                    textScaler: TextScaler.linear(2),
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Align(
                  child: Text(
                    'Ksh $balance',
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(3),
                    style: const TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 5, color: Colors.grey),
                        Shadow(blurRadius: 4, color: Colors.green),
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
