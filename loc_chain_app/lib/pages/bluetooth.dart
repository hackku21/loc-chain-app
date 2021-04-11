import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:flutter_udid/flutter_udid.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BluetoothPage extends StatefulWidget {
  BluetoothPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final Future<String> _id = FlutterUdid.consistentUdid;
  // String getId() =>
  //     SharedPreferences.getInstance().then((s) => s.getString('id') ?? '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<String>(
          future: _id, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            String content = "Loading id...";
            if (snapshot.hasData) {
              content = "ID: ${snapshot.data!}";
            }
            return ListView(
              children: <Widget>[
                Container(
                  child: Text(content),
                ),
              ],
            );
          }),
    );
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }
}
