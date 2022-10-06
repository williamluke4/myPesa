import 'package:flutter/material.dart';

class AreYouSureDialog extends StatelessWidget {
  const AreYouSureDialog({
    super.key,
    required this.onYes,
    this.onNo,
    this.title = const Text('Are You Sure?'),
    this.no = const Text('No'),
    this.yes = const Text('Yes'),
  });
  final void Function() onYes;
  final void Function()? onNo;
  final Widget yes;
  final Widget no;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are You Sure?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (onNo is Function) onNo!();
          },
          child: no,
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onYes();
          },
          child: yes,
        ),
      ],
    );
  }
}
