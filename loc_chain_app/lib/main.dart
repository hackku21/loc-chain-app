import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loc_chain_app/widgets/navbar.dart';
import 'dart:math';

void main() async {
  final prefs = await SharedPreferences.getInstance();
  final id = prefs.getString('id') ?? '0';
  if (id == '0') {
    prefs.setString('id', Random().nextInt(10000).toString());
  }

  runApp(App());
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
