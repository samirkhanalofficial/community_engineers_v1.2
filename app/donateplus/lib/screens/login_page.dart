import 'package:donateplus/functions/font.dart';
import 'package:donateplus/functions/loading_provider.dart';
import 'package:donateplus/functions/printerror.dart';
import 'package:donateplus/functions/vid_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoadingProvider(),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset("assets/logo.png"),
            ),
            const SizedBox(
              height: 50,
            ),
            Hero(
              tag: "title",
              child: Material(
                child: Text(
                  "Login",
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
                  "Enter your Mobile number",
                  style: skfont(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.grey.shade200,
              ),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset("assets/flag.png"),
                  ),
                  const Text("+977 - "),
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: _phone,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  )),
                ],
              ),
            ),
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
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              Provider.of<LoadingProvider>(context,
                                      listen: false)
                                  .changeisloading(true);
                              FirebaseAuth _auth = FirebaseAuth.instance;
                              await _auth.verifyPhoneNumber(
                                phoneNumber: "+977" + _phone.text,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {
                                  Provider.of<LoadingProvider>(context,
                                          listen: false)
                                      .changeisloading(false);
                                  debugPrint("verf complete");
                                },
                                verificationFailed: (FirebaseAuthException e) {
                                  Provider.of<LoadingProvider>(context,
                                          listen: false)
                                      .changeisloading(false);
                                  debugPrint("verification failed");

                                  printerror(
                                    context,
                                    title: "Verification Failed",
                                    desc: e.message.toString(),
                                  );
                                },
                                codeSent:
                                    (String vid, int? forceresendingtoken) {
                                  debugPrint("code sent");
                                  Provider.of<LoadingProvider>(context,
                                          listen: false)
                                      .changeisloading(false);
                                  Navigator.of(context).pushNamed("/verify",
                                      arguments: VidModel(vid));
                                },
                                codeAutoRetrievalTimeout: (vid) {
                                  Provider.of<LoadingProvider>(context,
                                          listen: false)
                                      .changeisloading(false);
                                  debugPrint("code timeout");
                                },
                              );
                            },
                            child: const Text("Next"),
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
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
