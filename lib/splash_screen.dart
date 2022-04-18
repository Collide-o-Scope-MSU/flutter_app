import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wrecks/screens/home/home.dart';
import 'package:wrecks/services/flutter_realtime_demo.dart';

class Splash extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<Splash> with SingleTickerProviderStateMixin {
  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FirebaseGetData()));
  }

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 91, 82),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: new Image.network(
                    'https://design.ece.msstate.edu/2022/team_dahal/static/images/logo.jpg',
                    height: 25.0,
                    fit: BoxFit.scaleDown,
                  ))
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Wireless Roadside Emergency Collision Kinetic Sensor",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'RobotoMono'),
                textAlign: TextAlign.center,
              ),
              Text(
                "WRECKS",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'RobotoMono'),
                textAlign: TextAlign.center,
              ),
              new Image.network(
                'https://design.ece.msstate.edu/2022/team_dahal/static/images/logo.jpg',
                width: animation.value * 550,
                height: animation.value * 550,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
