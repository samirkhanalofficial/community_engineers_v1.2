import 'dart:convert';

import 'package:bloodbank/functions/configs.dart';
import 'package:bloodbank/functions/font.dart';
import 'package:bloodbank/functions/loading_provider.dart';
import 'package:bloodbank/functions/printerror.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BloodBankDetailsScreen extends StatefulWidget {
  const BloodBankDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BloodBankDetailsScreen> createState() => _BloodBankDetailsScreenState();
}

class _BloodBankDetailsScreenState extends State<BloodBankDetailsScreen> {
  SharedPreferences? sf;
  bool temploading = true;
  final TextEditingController _location = TextEditingController(),
      _phone = TextEditingController();
  getdatas() async {
    // to  fetch datas from server
    if (temploading == true) {
      temploading = false;
      await Future.delayed(const Duration(seconds: 1));
    }
    Provider.of<LoadingProvider>(context, listen: false).changeisloading(true);

    sf = await SharedPreferences.getInstance();
    String? email = sf!.getString("email");
    String? password = sf!.getString("password");

    await http.post(Uri.parse(baseUrl + "/admin/details"), body: {
      "email": email,
      "password": password,
      "method": "GET",
    }).then((res) {
      Provider.of<LoadingProvider>(context, listen: false)
          .changeisloading(false);
      var parsedbody = jsonDecode(res.body);
      if (parsedbody["status"] == 1) {
        _location.text = parsedbody["datas"][0];
        _phone.text = parsedbody["datas"][1];
      } else {
        throw parsedbody["message"];
      }
    }).catchError((e) {
      Provider.of<LoadingProvider>(context, listen: false)
          .changeisloading(false);
      printerror(context, title: "Network Error", desc: e.toString());
    });
  }

  @override
  void initState() {
    getdatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                    onPressed: () {
                      getdatas();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh")),
              ),
            ],
          ),
          const Text(
              "These datas are public. So please make sure you enter correct information that can be made public."),
          Consumer<LoadingProvider>(builder: (_, value, __) {
            return value.loading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: Center(
                          child: LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.red,
                        size: 50,
                      )),
                    ),
                  )
                : SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: TextField(
                                controller: _location,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  label: Text(
                                    "Location",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: TextField(
                                controller: _phone,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  label: Text(
                                    "Phone",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                value.changeisloading(true);
                                String? email = sf!.getString("email");
                                String? password = sf!.getString("password");

                                await http.post(
                                    Uri.parse(baseUrl + "/admin/details"),
                                    body: {
                                      "email": email,
                                      "password": password,
                                      "method": "POST",
                                      "location": _location.text,
                                      "phone": _phone.text,
                                    }).then((res) {
                                  value.changeisloading(false);
                                  var parsedbody = jsonDecode(res.body);
                                  if (parsedbody["status"] == 1) {
                                    printerror(context,
                                        title: "Change Saved",
                                        desc:
                                            "Changes have been saved successfully");
                                  } else {
                                    throw parsedbody["message"];
                                  }
                                }).catchError((e) {
                                  value.changeisloading(false);
                                  printerror(context,
                                      title: "Network Error",
                                      desc: e.toString());
                                });
                              },
                              child: const Text("Save Changes")),
                        ),
                      ],
                    ),
                  );
          })
        ],
      ),
    );
  }
}
