import 'package:flutter/material.dart';

class RememberProvider extends ChangeNotifier {
  bool _remember = true;
  RememberProvider();
  changeremember(bool value) {
    _remember = value;
    notifyListeners();
  }

  bool get isremember => _remember;
}
