import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BluetoothPage extends StatefulWidget {
  BluetoothPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  // final String id = getId();
  // String getId() =>
  //     SharedPreferences.getInstance().then((s) => s.getString('id') ?? '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("GetID"),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            final id = prefs.getString('id');

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Id is $id")));
          },
        ),
      ),
    );
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }
}
