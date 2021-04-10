import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Connect {
  void startConnect() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName') ?? " ";
    final Strategy strategy = Strategy.P2P_STAR;
    final serviceId = "com.yourdomain.appname";

    try {
      bool advertise = await Nearby().startAdvertising(
        userName,
        strategy,
        onConnectionInitiated: (String id, ConnectionInfo info) {
          // Called whenever a discoverer requests connection
        },
        onConnectionResult: (String id, Status status) {
          // Called when connection is accepted/rejected
        },
        onDisconnected: (String id) {
          // Callled whenever a discoverer disconnects from advertiser
        },
        serviceId: serviceId, // uniquely identifies your app
      );
      bool discovery = await Nearby().startDiscovery(
        userName,
        strategy,
        onEndpointFound: (String id, String userName, String serviceId) {
          // called when an advertiser is found
        },
        onEndpointLost: (String? id) {
          //called when an advertiser is lost (only if we weren't connected to it )
        },
        serviceId: serviceId, // uniquely identifies your app
      );
    } catch (exception) {
      // platform exceptions like unable to start bluetooth or insufficient permissions
    }
  }
}
