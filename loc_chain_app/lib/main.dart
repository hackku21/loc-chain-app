import 'package:flutter/material.dart';
import 'package:loc_chain_app/widgets/navbar.dart';

void main() {
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
