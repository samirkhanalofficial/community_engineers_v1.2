// ignore_for_file: unnecessary_null_comparison

import 'package:donateplus/checkloginedpage.dart';
import 'package:donateplus/screens/home_screen.dart';
import 'package:donateplus/screens/login_page.dart';
import 'package:donateplus/screens/notif_screen.dart';
import 'package:donateplus/screens/register_screen.dart';
import 'package:donateplus/screens/verify_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title// description
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  var datas = message.data;

  await Firebase.initializeApp();
  debugPrint('A bg message just showed up :  ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB7aVnhIEnHjURWwj-da6xGuNgKaGLlnew",
          appId: "1:132373144901:android:887db34fb586c39e768a2c",
          messagingSenderId: "132373144901",
          projectId: "donateplus-cd4d5"));
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher')),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyApp(),
        "/login": (context) => const LoginPage(),
        "/verify": (context) => const VerifyScreen(),
        "/register": (context) => const RegisterScreen(),
        "/home": (context) => const HomeScreen(),
        "/notifscreen": (context) => const NotifScreen(),
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _handleMessage(RemoteMessage message) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NotifScreen(
              message: message,
            )));
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("onMessageOpened");
      _handleMessage(message);
    });
    // Also handle any interaction when the app is in the background via a
    // Stream listener
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      var datas = message.data;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
                styleInformation: BigTextStyleInformation(notification.body!),
              ),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const CheckLogginedPage();
  }
}
