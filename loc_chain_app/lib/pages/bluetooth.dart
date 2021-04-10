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
  final id = SharedPreferences.getInstance().then((s) => s.getString('id'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('$id'),
      ),
    );
  }
}
