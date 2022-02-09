import 'package:flutter/material.dart';

class ObsecureProvider extends ChangeNotifier {
  bool _obsecure = true;
  ObsecureProvider();
  changeisobsecure(bool value) {
    _obsecure = value;
    notifyListeners();
  }

  bool get issobsecure => _obsecure;
}
