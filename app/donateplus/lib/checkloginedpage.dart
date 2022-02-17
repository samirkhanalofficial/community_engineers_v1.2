import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckLogginedPage extends StatefulWidget {
  const CheckLogginedPage({Key? key}) : super(key: key);

  @override
  State<CheckLogginedPage> createState() => _CheckLogginedPageState();
}

class _CheckLogginedPageState extends State<CheckLogginedPage> {
  isloggined() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    bool? _isloggined = sf.getBool("isloginned");
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? _user = _auth.currentUser;
    if (_user == null) {
      Navigator.of(context).pushReplacementNamed("/login");
    } else {
      if (_isloggined!) {
        Navigator.of(context).pushReplacementNamed("/home");
      } else {
        await _auth.signOut();
        Navigator.of(context).pushReplacementNamed("/login");
      }
    }
  }

  @override
  void initState() {
    isloggined();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Hero(
                tag: "logo",
                child: Material(
                  child: Image.asset("assets/logo.png"),
                ),
              ),
            ),
          ),
          const Positioned(
              left: 0,
              right: 0,
              bottom: 50,
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              ))
        ],
      ),
    );
  }
}
