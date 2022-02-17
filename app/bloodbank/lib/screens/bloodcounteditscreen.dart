import 'dart:convert';

import 'package:bloodbank/functions/configs.dart';
import 'package:bloodbank/functions/printerror.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BloodCountEditScreen extends StatefulWidget {
  const BloodCountEditScreen({Key? key}) : super(key: key);

  @override
  State<BloodCountEditScreen> createState() => _BloodCountEditScreenState();
}

class _BloodCountEditScreenState extends State<BloodCountEditScreen> {
  fetchdata() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    await http.post(Uri.parse(baseUrl + "/admin/get"), body: {
      "email": sf.getString("email"),
      "password": sf.getString("password"),
    }).then((value) {
      var res = jsonDecode(value.body);
      debugPrint(res);
    }).catchError((e) {
      debugPrint(e.toString());
      printerror(context, title: "Network Error", desc: e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fetchdata();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
    );
  }
}
