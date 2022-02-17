import 'package:flutter/material.dart';

class BloodGroupProvider extends ChangeNotifier {
  String _value = "A+";
  BloodGroupProvider();
  changevalue(String value) {
    _value = value;
    notifyListeners();
  }

  String get value => _value;
}
