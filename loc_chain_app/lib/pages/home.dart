import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:loc_chain_app/util/transaction_manager.dart';
import 'package:nearby_connections/nearby_connections.dart';

import 'package:loc_chain_app/util/keyfile_manager.dart';
import 'package:loc_chain_app/util/transaction_manager.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getUUID();
      startAdvertising();
      startDiscovery();
    });
  }

  static late String userName;
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = Map();
  static Map<String, Transaction> transactionMap = Map();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Text("User Name: " + userName),
            Divider(),
            Text("Number of connected devices: ${endpointMap.length}"),
            ElevatedButton(
              child: Text("Stop All Endpoints"),
              onPressed: () async {
                await Nearby().stopAllEndpoints();
                setState(() {
                  endpointMap.clear();
                });
              },
            ),
            Divider(),
            Text(
              "Sending Data",
            ),
            ElevatedButton(
              child: Text("Send Bytes Payload"),
              onPressed: () async {
                sendPayload();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> genPayload(ConnectionInfo value) async {
    print("Sender ID: $userName");
    print("Receiver ID: ${value.endpointName}");

    var dateTime = DateTime.now();

    print('Milliseconds since Epoch: ${dateTime.millisecondsSinceEpoch}');

    Transaction p2p = await Transaction.create(value.endpointName);
    String json = jsonEncode(p2p);
    return json;
  }

  void sendPayload() async {
    endpointMap.forEach((key, value) async {
      String a = await genPayload(value);

      showSnackbar("Sending $a to ${value.endpointName}, id: $key");
      Nearby().sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
    });
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  void getUUID() async {
    userName = await FlutterUdid.consistentUdid;
  }

  void stopAll() async {
    await Nearby().stopAllEndpoints();
    await Nearby().stopAdvertising();
    await Nearby().stopDiscovery();
    setState(() {});
  }

  void startDiscovery() async {
    try {
      userName = await FlutterUdid.consistentUdid;
      bool a = await Nearby().startDiscovery(
        userName,
        strategy,
        onEndpointFound: (id, name, serviceId) {
          print("userName = $userName");
          print("id = $id");

          Nearby().requestConnection(
            userName,
            id,
            onConnectionInitiated: (id, info) {
              onConnectionInit(id, info);
              sleep(Duration(microseconds: 500));
              sendPayload();
            },
            onConnectionResult: (id, status) {
              showSnackbar(status);
            },
            onDisconnected: (id) {
              setState(() {
                endpointMap.remove(id);
              });
              showSnackbar(
                  "Disconnected from: ${endpointMap[id]!.endpointName}, id $id");
            },
          );
        },
        onEndpointLost: (id) {
          showSnackbar(
              "Lost discovered Endpoint: ${endpointMap[id]!.endpointName}, id $id");
        },
      );
      showSnackbar("DISCOVERING: " + a.toString());
    } catch (e) {
      showSnackbar(e);
    }
    setState(() {});
  }

  void startAdvertising() async {
    try {
      userName = await FlutterUdid.consistentUdid;

      bool a = await Nearby().startAdvertising(
        userName,
        strategy,
        onConnectionInitiated: (id, info) {
          onConnectionInit(id, info);
          sleep(Duration(microseconds: 500));
          sendPayload();
        }, //advertisingOnConnectionInit,
        onConnectionResult: (id, status) {
          print("userName = $userName");
          print("id = $id");
          print(status);
          showSnackbar(status);
        },
        onDisconnected: (id) {
          showSnackbar(
              "Disconnected: ${endpointMap[id]!.endpointName}, id $id");
          setState(() {
            endpointMap.remove(id);
          });
        },
      );
      showSnackbar("ADVERTISING: " + a.toString());
    } catch (exception) {
      showSnackbar(exception);
    }
    setState(() {});
  }

  /// Called upon Connection request (on both devices)
  /// Both need to accept connection to start sending/receiving
  void onConnectionInit(String id, ConnectionInfo info) {
    setState(() {
      endpointMap[id] = info;
    });
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) async {
        if (payload.type == PayloadType.BYTES) {
          Transaction transaction = Transaction.fromJson(jsonDecode(
            String.fromCharCodes(payload.bytes!),
          ));

          // first device recives here
          print("Receiving:");
          print("${transaction.hash}");

          showSnackbar(endid + ": " + transaction.hash);
        }
      },
      onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
        if (payloadTransferUpdate.status == PayloadStatus.IN_PROGRESS) {
          print(payloadTransferUpdate.bytesTransferred);
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          print("failed");
          showSnackbar(endid + ": FAILED to transfer file");
        } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {
          showSnackbar(
              "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");
        }
      },
    );
  }
}
