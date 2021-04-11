import 'package:flutter/material.dart';
import 'package:loc_chain_app/util/bluetooth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loc_chain_app/widgets/navbar.dart';
import 'package:flutter_udid/flutter_udid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
  (await SharedPreferences.getInstance())
      .setString('userName', await FlutterUdid.consistentUdid);
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Connect.start();

    return MaterialApp(
      title: 'Loc-Chain',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: NavBarWidget(),
    );
  }
}
