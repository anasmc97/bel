import 'dart:async';

import 'package:bel/auth.dart';
import 'package:flutter/material.dart';

class LauncherPage extends StatefulWidget {
  final String id = "launcher_screen";
  @override
  _LauncherPageState createState() => new _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override

  void initState(){
    super.initState();
    startLaunching();
  }
  
  startLaunching() async {
    var duration = const Duration(seconds: 5);
    return new Timer(duration, (){
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (_){
        return  Auth();
      }));
    });
  }

  Widget build(BuildContext context) {

    var image = new Image.asset(
        "assets/unram.png",
        height: 150.0,
        width: 150.0,
      );
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: new Center(
          child: image,),
    );
  }
}