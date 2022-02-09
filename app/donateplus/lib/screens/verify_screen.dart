import 'dart:convert';

import 'package:donateplus/functions/configs.dart';
import 'package:donateplus/functions/font.dart';
import 'package:donateplus/functions/loading_provider.dart';
import 'package:donateplus/functions/printerror.dart';
import 'package:donateplus/functions/vid_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String _vid = "", _code = "";
  verify(BuildContext context) async {
    debugPrint("verifying");
    Provider.of<LoadingProvider>(context, listen: false).changeisloading(true);
    FirebaseAuth _auth = FirebaseAuth.instance;
    PhoneAuthCredential _credential =
        PhoneAuthProvider.credential(verificationId: _vid, smsCode: _code);

    await _auth
        .signInWithCredential(_credential)
        .then((UserCredential _userCred) async {
      User user = _userCred.user!;
      await user.getIdToken().then((String _token) async {
        debugPrint(_token);
        await http.post(Uri.parse(baseUrl + "/login"),
            body: {"token": _token}).then((_res) {
          var result = jsonDecode(_res.body);

          if (result["status"] == 11) {
            Navigator.of(context).pushNamed("/register");
          } else if (result["status"] == 1) {
            Navigator.of(context).pushNamed("/home");
          } else {
            printerror(context,
                title: "Login Error",
                desc: result["message"] ?? "something went wrong");
          }
          Provider.of<LoadingProvider>(context, listen: false)
              .changeisloading(false);
        }).catchError((e) {
          // error in http req
          Provider.of<LoadingProvider>(context, listen: false)
              .changeisloading(false);

          printerror(context,
              title: "Internet Connection Error",
              desc:
                  "Please make sure you are connected to the internet and try again");
        });
      }).catchError((e) {
        // error in retriving token
        Provider.of<LoadingProvider>(context, listen: false)
            .changeisloading(false);

        printerror(context, title: "Something went wrong", desc: e.toString());
      });
    }).catchError((e) {
      // error of verification failed
      Provider.of<LoadingProvider>(context, listen: false)
          .changeisloading(false);

      printerror(context,
          title: "Verification Failed",
          desc: "The code you entered is incorrect.");
    });
  }

  @override
  Widget build(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as VidModel;
    _vid = _args.vid;
    return ChangeNotifierProvider(
      create: (context) => LoadingProvider(),
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset("assets/verify.png"),
              ),
              const SizedBox(
                height: 50,
              ),
              Hero(
                tag: "title",
                child: Material(
                  child: Text(
                    "Verification",
                    style: skfont(
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
              Hero(
                tag: "subtitle",
                child: Material(
                  child: Text(
                    "Please enter the 6-digit verification code sent to your number.",
                    style: skfont(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.shade200,
                  ),
                  width: double.infinity,
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Colors.black,
                    ),
                    child: PinCodeTextField(
                      appContext: context,
                      enablePinAutofill: true,
                      animationType: AnimationType.none,
                      animationDuration: const Duration(milliseconds: 1),
                      pinTheme: PinTheme(
                          activeColor: Colors.black,
                          inactiveColor: Colors.black,
                          selectedColor: Colors.black),
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      length: 6,
                      onChanged: (str) {
                        _code = str;
                      },
                      onSubmitted: (str) => verify(context),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Consumer<LoadingProvider>(
                builder: (context, value, child) => (value.loading)
                    ? const Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Hero(
                        tag: "button",
                        child: Material(
                          child: Container(
                            decoration: const BoxDecoration(),
                            height: 65,
                            child: ElevatedButton(
                              onPressed: () => verify(context),
                              child: const Text("Verify"),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              )),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
