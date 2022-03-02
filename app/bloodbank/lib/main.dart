import 'package:bloodbank/functions/remember_provider.dart';
import 'package:bloodbank/functions/bloodgroupprovider.dart';
import 'package:bloodbank/screens/dashboard_screen.dart';
import 'package:bloodbank/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'functions/loading_provider.dart';
import 'functions/obsecure_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.setMinimumSize(const Size(800, 500));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoadingProvider>(
          create: (context) => LoadingProvider(),
        ),
        ChangeNotifierProvider<ObsecureProvider>(
          create: (context) => ObsecureProvider(),
        ),
        ChangeNotifierProvider(
          create: ((context) => RememberProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => BloodGroupProvider()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        themeMode: ThemeMode.dark,
        initialRoute: "/",
        routes: {
          "/": (context) => const LoginScreen(),
          "/dashboard": ((context) => const DashboardScreen()),
        },
      ),
    );
  }
}
