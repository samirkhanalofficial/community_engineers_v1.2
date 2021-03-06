import 'package:flutter/material.dart';

printerror(BuildContext context,
    {required String title, required String desc}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(title),
      content: Text(desc),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("ok"))
      ],
    ),
  );
}
