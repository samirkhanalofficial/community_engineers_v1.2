import 'package:donateplus/screens/home_screen.dart';
import 'package:donateplus/screens/login_page.dart';
import 'package:donateplus/screens/register_screen.dart';
import 'package:donateplus/screens/verify_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const LoginPage(),
        "/verify": (context) => const VerifyScreen(),
        "/register": (context) => const RegisterScreen(),
        "home": (context) => const HomeScreen(),
      },
    );
  }
}
