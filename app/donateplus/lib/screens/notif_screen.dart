import 'package:flutter/material.dart';

class NotifScreen extends StatefulWidget {
  var message;
  NotifScreen({Key? key, this.message}) : super(key: key);

  @override
  State<NotifScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint(widget.message.toString());
    return Scaffold();
  }
}
