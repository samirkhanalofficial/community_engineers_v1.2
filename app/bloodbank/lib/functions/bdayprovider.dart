import 'package:flutter/material.dart';

class BdayProvider extends ChangeNotifier {
  DateTime? _bday = DateTime.now();
  BdayProvider();
  getbday() {
    return _bday;
  }

  changebday(DateTime tbday) {
    _bday = tbday;
    notifyListeners();
  }
}
