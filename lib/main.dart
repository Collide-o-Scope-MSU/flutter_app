import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wrecks/screens/home/home.dart';
import 'package:wrecks/services/flutter_realtime_demo.dart';
import 'package:wrecks/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB4QJFS782zKXLTcx3uowP54PeywwJF3Xc",
            appId: "1:640557904214:web:1a05e736578dde9c16e6f7",
            databaseURL: "https://wrecks-24e46-default-rtdb.firebaseio.com",
            messagingSenderId: "640557904214",
            projectId: "wrecks-24e46"));
  } catch (e) {
    print(e);
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  AwesomeNotifications().initialize('resource://drawable/car_crash', [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: "Basic Notifications",
        channelDescription: "Please check the app.",
        importance: NotificationImportance.High,
        defaultColor: Colors.teal,
        channelShowBadge: true,
        ledColor: Colors.white)
  ]);
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

// Declared as global, outside of any class
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.messageId}");

  // Use this method to automatically convert the push data, in case you gonna use our data standard
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}
