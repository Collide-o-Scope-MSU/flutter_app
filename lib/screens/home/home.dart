import 'dart:ffi';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:wrecks/constants/constants.dart';
import 'package:wrecks/models/userModel.dart';
import 'package:wrecks/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

bool gotData = false;

class FirebaseGetData extends StatefulWidget {
  FirebaseGetData({Key? key}) : super(key: key);

  @override
  State<FirebaseGetData> createState() => _FirebaseGetDataState();
}

class _FirebaseGetDataState extends State<FirebaseGetData> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('/');

  final List<UserModel>? growableList = <UserModel>[];

  int count = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Allow Notifications"),
                  content: Text(
                      'App needs to send notification during collision detection!'),
                  actions: [
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Don\'t allow',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        )),
                    TextButton(
                        onPressed: () => AwesomeNotifications()
                            .requestPermissionToSendNotifications()
                            .then((value) => Navigator.pop(context)),
                        child: Text(
                          'Allow',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ))
                  ],
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    count = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text("WRECKS"),
        ),
        body: StreamBuilder(
          stream: starCountRef.onValue,
          builder: (ctx, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final data = snapshot.data!.snapshot.value;
              //print(data);
              //List<Map> lists;
              Map<String, dynamic> map = json.decode(data.toString());

              final length = map.length;
              //print(map["Cellular1"]);
              for (int i = 1; i < length; i++) {
                //print(map["LoRA5"]);
                if (map["Cellular$i"] != null) {
                  //print(map["Cellular$i"]);

                  UserModel user = UserModel.fromJson(map["Cellular$i"]);
                  user.type = "Cellular";
                  //print(user);
                  if (growableList?.indexOf(user) == -1) {
                    growableList?.add(user);
                    count++;
                  }
                }
                if (map["LoRA$i"] != null) {
                  print(map["LoRA$i"]);
                  UserModel user = UserModel.fromJson(map["LoRA$i"]);
                  user.type = "LoRa";
                  //print(user);
                  if (growableList?.indexOf(user) == -1) {
                    growableList?.add(user);
                    count++;
                  }
                }
              }

              //String user = jsonEncode(data);

              print(growableList);

              //UserModel myuser = UserModel.fromJson(data);
              //print(myuser);
              //var tagObjsJson = json.decode(data.toString());
              //print(user);
              //UserModel user = UserModel.fromJson(tagObjsJson);
              //List tagObjs =
              //  tagObjsJson.map((user) => UserModel.fromJson(user)).toList();
              //print(user);

              return ListView.builder(
                itemCount: length,
                itemBuilder: (BuildContext ctx, i) => Container(
                  height: 100,
                  width: 100,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          title: Text(
                            'ID: ${growableList?.elementAt(i).id}  Voltage: ${growableList?.elementAt(i).battery}',
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                              'GPS: ${growableList?.elementAt(i).GPS}\nLatest_Update: ${growableList?.elementAt(i).time}\nStatus: ${growableList?.elementAt(i).status}'),
                          leading: Image.asset(
                              'assets/images/${growableList?.elementAt(i).type}.jpg'),
                          trailing: const Icon(Icons.battery_std),
                          onTap: () {
                            final gps =
                                growableList?.elementAt(i).GPS?.split(',');

                            openMap(
                                double.parse(gps![0]), double.parse(gps[1]));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('There is something wrong!'),
              );
            }
          },
        ));
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleUrl) != null) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
