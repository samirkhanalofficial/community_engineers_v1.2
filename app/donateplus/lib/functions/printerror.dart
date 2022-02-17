import 'package:flutter/material.dart';

printerror(BuildContext context,
    {required String title, required String desc}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      content: Text(desc),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("ok"))
      ],
    ),
  );
}
