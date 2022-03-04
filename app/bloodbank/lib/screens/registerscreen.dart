import 'dart:convert';
import 'dart:ui';

import 'package:bloodbank/functions/configs.dart';
import 'package:bloodbank/functions/font.dart';
import 'package:bloodbank/functions/loading_provider.dart';
import 'package:bloodbank/functions/obsecure_provider.dart';
import 'package:bloodbank/functions/printerror.dart';
import 'package:bloodbank/functions/remember_provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _adminemail = TextEditingController();
  final TextEditingController _adminpassword = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _location = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: [
          Image.asset(
            "assets/bg6.jpg",
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 2,
                sigmaY: 2,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                width: 700,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.arrow_back)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Image.asset(
                            "assets/logo.png",
                            width: 250,
                            height: 250,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Text(
                            "Blood Bank Register",
                            style: skfont(
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.grey.shade200,
                            ),
                            width: double.infinity,
                            child: TextField(
                              controller: _adminemail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.alternate_email),
                                hintText: "Admin Email",
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.grey.shade200,
                            ),
                            width: double.infinity,
                            child: TextField(
                              controller: _adminpassword,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.lock),
                                hintText: "Admin Password",
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.grey.shade200,
                            ),
                            width: double.infinity,
                            child: TextField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.alternate_email),
                                hintText: "Bloodbank email",
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.grey.shade200,
                            ),
                            width: double.infinity,
                            child: TextField(
                              controller: _password,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.lock),
                                hintText: "Bloodbank password",
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.grey.shade200,
                            ),
                            width: double.infinity,
                            child: TextField(
                              controller: _phone,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.phone),
                                hintText: "phone",
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.grey.shade200,
                            ),
                            width: double.infinity,
                            child: TextField(
                              controller: _location,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.location_on),
                                hintText: "Location",
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: Consumer<LoadingProvider>(
                                builder: (context, value, _) {
                              return value.loading
                                  ? LoadingAnimationWidget.threeArchedCircle(
                                      color: Colors.white,
                                      size: 50,
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await value.changeisloading(true);
                                        await http.post(
                                            Uri.parse(baseUrl +
                                                "/admin/adminregister"),
                                            body: {
                                              "email": _email.text,
                                              "password": _password.text,
                                              "location": _location.text,
                                              "phone": _phone.text,
                                              "adminemail": _adminemail.text,
                                              "adminpassword":
                                                  _adminpassword.text,
                                            }).then((res) async {
                                          var parsedbody = jsonDecode(res.body);
                                          if (parsedbody["status"] == 1) {
                                            await printerror(context,
                                                title: "Success",
                                                desc: parsedbody["message"]);
                                            await value.changeisloading(false);
                                          } else {
                                            throw parsedbody["message"];
                                          }
                                        }).catchError((e) async {
                                          await printerror(context,
                                              title: "Error",
                                              desc: e.toString());
                                          await value.changeisloading(false);
                                        });
                                      },
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                      ),
                                    );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
