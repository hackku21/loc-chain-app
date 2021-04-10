import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(children: <Widget>[
          Text(
            "Permissions",
          ),
          Wrap(
            children: <Widget>[
              ElevatedButton(
                child: Text("checkLocationPermission"),
                onPressed: () async {
                  if (await Nearby().checkLocationPermission()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Location permissions granted :)")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Location permissions not granted :(")));
                  }
                },
              ),
              ElevatedButton(
                child: Text("askLocationPermission"),
                onPressed: () async {
                  if (await Nearby().askLocationPermission()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Location Permission granted :)")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Location permissions not granted :(")));
                  }
                },
              ),
              ElevatedButton(
                child: Text("checkExternalStoragePermission"),
                onPressed: () async {
                  if (await Nearby().checkExternalStoragePermission()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("External Storage permissions granted :)")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "External Storage permissions not granted :(")));
                  }
                },
              ),
              ElevatedButton(
                child: Text("askExternalStoragePermission"),
                onPressed: () {
                  Nearby().askExternalStoragePermission();
                },
              ),
            ],
          ),
          Divider(),
          Text("Location Enabled"),
          Wrap(
            children: <Widget>[
              ElevatedButton(
                child: Text("checkLocationEnabled"),
                onPressed: () async {
                  if (await Nearby().checkLocationEnabled()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Location is ON :)")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Location is OFF :(")));
                  }
                },
              ),
              ElevatedButton(
                child: Text("enableLocationServices"),
                onPressed: () async {
                  if (await Nearby().enableLocationServices()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Location Service Enabled :)")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Enabling Location Service Failed :(")));
                  }
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
