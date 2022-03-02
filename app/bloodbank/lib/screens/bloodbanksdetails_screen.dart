import 'dart:convert';

import 'package:bloodbank/functions/configs.dart';
import 'package:bloodbank/functions/font.dart';
import 'package:bloodbank/functions/printerror.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BloodBankDetailsScreen extends StatefulWidget {
  const BloodBankDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BloodBankDetailsScreen> createState() => _BloodBankDetailsScreenState();
}

class _BloodBankDetailsScreenState extends State<BloodBankDetailsScreen> {
  SharedPreferences? sf;
  getdatas() async {
    // to  fetch datas from server
    sf = await SharedPreferences.getInstance();
    String? email = sf!.getString("email");
    String? password = sf!.getString("password");

    await http
        .get(
      Uri.parse(baseUrl + "/admin/details?email=$email+password=$password"),
    )
        .then((res) {
      var parsedbody = jsonDecode(res.body);
      debugPrint(parsedbody.toString());
    }).catchError((e) =>
            printerror(context, title: "Network Error", desc: e.toString()));
  }

  @override
  Widget build(BuildContext context) {
    getdatas();
    return Scaffold(
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Details / Contact:",
                style: skfont(
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
