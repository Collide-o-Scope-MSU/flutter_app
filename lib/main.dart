import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wrecks/screens/home/home.dart';
import 'package:wrecks/services/flutter_realtime_demo.dart';
import 'package:wrecks/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize('../assets/images/LoRa.png', [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: "Basic Notification",
        channelDescription: "Please check the app.",
        importance: NotificationImportance.High,
        defaultColor: Colors.teal,
        channelShowBadge: true)
  ]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Splash(),
    );
  }
}
