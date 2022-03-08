import 'package:donateplus/screens/home_screen.dart';
import 'package:donateplus/screens/login_page.dart';
import 'package:donateplus/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckLogginedPage extends StatefulWidget {
  const CheckLogginedPage({Key? key}) : super(key: key);

  @override
  State<CheckLogginedPage> createState() => _CheckLogginedPageState();
}

class _CheckLogginedPageState extends State<CheckLogginedPage> {
  bool? islogged;
  isloggined() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    bool? _isloggined = sf.getBool("isloginned");
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? _user = _auth.currentUser;
    if (_user == null) {
      setState(() {
        islogged = false;
      });
    } else {
      if (_isloggined!) {
        setState(() {
          islogged = true;
        });
      } else {
        await _auth.signOut();
        setState(() {
          islogged = false;
        });
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
    return islogged != null
        ? (islogged == true ? const HomeScreen() : const LoginPage())
        : Scaffold(
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
