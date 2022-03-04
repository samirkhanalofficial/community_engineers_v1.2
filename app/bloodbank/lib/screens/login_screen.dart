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

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  SharedPreferences? sf;
  initializeshared() async {
    sf = await SharedPreferences.getInstance();
    if (sf!.getBool("remember") == true) {
      Navigator.of(context).pushReplacementNamed("/dashboard");
    }
  }

  @override
  void initState() {
    initializeshared();
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
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset(
                        "assets/logo.png",
                        width: 300,
                        height: 300,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Blood Bank Login",
                            style: skfont(
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            " Enter your email and password",
                            style: skfont(
                                style: const TextStyle(
                              color: Colors.white,
                            )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            " Email :",
                            style: skfont(
                                style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
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
                                hintText: "Email",
                              ),
                            ),
                          ),
                          Text(
                            " Password :",
                            style: skfont(
                                style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
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
                            child: Consumer<ObsecureProvider>(
                                builder: (context, value, _) {
                              bool _isobsecure = value.issobsecure;
                              return TextField(
                                controller: _password,
                                obscureText: value.issobsecure,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  hintText: "Password",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      value.changeisobsecure(!_isobsecure);
                                    },
                                    icon: Icon(_isobsecure
                                        ? Icons.visibility_off_outlined
                                        : Icons.remove_red_eye_outlined),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Consumer<RememberProvider>(
                                  builder: (context, value, _) {
                                return Checkbox(
                                  value: value.isremember,
                                  onChanged: (val) {
                                    value.changeremember(val!);
                                  },
                                  checkColor: Colors.white,
                                  focusColor: Colors.red,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      (states) => Colors.red),
                                );
                              }),
                              Text(
                                "Remember me",
                                style: skfont(
                                    style: const TextStyle(
                                  color: Colors.white,
                                )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
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
                                            Uri.parse(baseUrl + "/admin/login"),
                                            body: {
                                              "email": _email.text,
                                              "password": _password.text,
                                            }).then((res) async {
                                          debugPrint(res.statusCode.toString());
                                          if (res.statusCode == 200) {
                                            var parsedres =
                                                jsonDecode(res.body);
                                            if (parsedres["status"] == 1) {
                                              if (Provider.of<RememberProvider>(
                                                      context,
                                                      listen: false)
                                                  .isremember) {
                                                sf!.setBool("remember", true);
                                              }

                                              sf!.setString(
                                                  "email", _email.text);
                                              sf!.setString("password",
                                                  parsedres["message"]);

                                              await value
                                                  .changeisloading(false);
                                              await Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      "/dashboard");
                                            } else {
                                              await printerror(context,
                                                  title: "Login Error",
                                                  desc: "" +
                                                      parsedres["message"]);
                                              await value
                                                  .changeisloading(false);
                                            }
                                          } else {
                                            await printerror(context,
                                                title: "Network Error",
                                                desc:
                                                    "There might be some problem in the server. \nPlease try again later.");
                                            await value.changeisloading(false);
                                          }
                                        }).catchError((e) async {
                                          await printerror(context,
                                              title: "Network Error",
                                              desc:
                                                  "Please make sure you are connected to internet. \nIf you have a stable internet connection \nplease try again later cause there \nmight be problem in the server.");
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
          Positioned(
            bottom: 8,
            right: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/register'),
                child: const Text("Admin Panel"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
