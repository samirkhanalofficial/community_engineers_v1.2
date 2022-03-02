import 'package:flutter/cupertino.dart';

class BloodGroupProvider extends ChangeNotifier {
  String bloodgroup = "A+";
  changebloodgroup(String _bloodgroup) {
    bloodgroup = _bloodgroup;
    notifyListeners();
  }

  get bloodgroupp => bloodgroup;
}
