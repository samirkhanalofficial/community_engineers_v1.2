import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  bool _loading = false;
  LoadingProvider();
  changeisloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get loading => _loading;
}
