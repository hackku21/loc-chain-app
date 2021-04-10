import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loc_chain_app/widgets/navbar.dart';
import 'dart:math';

void main() async {
  runApp(App());
  final prefs = await SharedPreferences.getInstance();
  final userName = prefs.getString('userName') ?? '0';
  if (userName == '0') {
    prefs.setString('id', Random().nextInt(10000).toString());
  }
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: NavBarWidget(),
    );
  }
}
