
import 'package:bel/LauncherView.dart';

import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bel Sekolah',
      theme: new ThemeData(
        primaryColor: Colors.white,
        //accentColor: Colors.white,
      ),
      home: LauncherPage(),
    );
  }
}


