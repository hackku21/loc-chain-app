import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:nearby_connections/nearby_connections.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:loc_chain_app/util/keyfile_manager.dart';
import 'package:loc_chain_app/util/transaction_manager.dart';

class Connect {
  static final serviceId = "com.yourdomain.appname";
  static final Strategy strategy = Strategy.P2P_STAR;
  static String _userName = "";
  static BuildContext? context;

  static Map<String, ConnectionInfo> endpointMap = Map();
  static Map<String, Transaction> transactionMap = Map();

  static void showSnackbar(dynamic a) {
    if (context == null) {
      return;
    }
    ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  static void stop() {
    Nearby().stopAdvertising();
    Nearby().stopDiscovery();
    Nearby().stopAllEndpoints();
  }

  static void start() async {
    _userName = await FlutterUdid.consistentUdid;
    // final prefs = await SharedPreferences.getInstance();
    // final userName = prefs.getString('userName') ?? " ";

    Nearby().startAdvertising(
      _userName,
      strategy,
      onConnectionInitiated: onConnectionInit,
      onConnectionResult: (String id, Status status) async {
        // Called when connection is accepted/rejected
        // if connection is accepted send the transaction
        if (status != Status.CONNECTED) {
          return;
        }
        // Connected to other device, send combined hash and pub key
        String str = await Transaction.generateHash(id);
        print(str);
        Nearby().sendBytesPayload(id, Uint8List.fromList(str.codeUnits));
      },
      onDisconnected: (String id) {
        // Callled whenever a discoverer disconnects from advertiser
        // delete connection info
        endpointMap.remove(id);
        // delete transaction info
        transactionMap.remove(id);
      },
      serviceId: serviceId, // uniquely identifies your app
    ).catchError((e) {
      print(e);
      return true;
    });

    Nearby().startDiscovery(
      _userName,
      strategy,
      onEndpointFound: (String id, String userName, String serviceId) {
        // called when an advertiser is found
        Nearby().requestConnection(
          userName,
          id,
          onConnectionInitiated: onConnectionInit,
          onConnectionResult: (String id, Status status) async {
            // Called when connection is accepted/rejected
            // if connection is accepted send the transaction
            if (status != Status.CONNECTED) {
              return;
            }
            // Connected to other device, send combined hash and pub key
            String str = await Transaction.generateHash(id);
            Nearby()
                .sendBytesPayload(id, Uint8List.fromList(str.codeUnits))
                .catchError((e) {
              print(e);
            });
          },
          onDisconnected: (id) {
            endpointMap.remove(id);
            print(
                "Disconnected from: ${endpointMap[id]!.endpointName}, id $id");
          },
        ).catchError((e) {
          print(e);
          return true;
        });
      },
      onEndpointLost: (String? id) {
        //called when an advertiser is lost (only if we weren't connected to it )
      },
      serviceId: serviceId, // uniquely identifies your app
    ).catchError((e) {
      print(e);
      return true;
    });
  }

  static void onConnectionInit(String otherId, ConnectionInfo info) {
    print('Connection initialized with $otherId');
    // Called whenever a discoverer requests connection
    //
    // onConnectionInit
    if (endpointMap.containsKey(otherId)) {
      print('Connection rejected to/from $otherId');
      Nearby().rejectConnection(otherId);
      return;
    }
    print('Connection accepted to/from $otherId');

    endpointMap[otherId] = info;
    Nearby().acceptConnection(
      otherId,
      onPayLoadRecieved: (_otherId, payload) async {
        if (payload.type != PayloadType.BYTES) return;
        // completed payload from other connection
        String str = String.fromCharCodes(payload.bytes!);
        var parts = str.split(':');
        if (parts.length != 2) {
          print("$_otherId invalid payload: $str");
          return;
        }
        // Store transaction
        var combinedHash = parts[0];
        var publicKey = parts[1];
        transactionMap[_otherId] =
            Transaction(hash: combinedHash, pubKey: publicKey);
        // sign combined hash with our private key
        print('Received $_otherId payload: $combinedHash:$publicKey');
        // upload hash+otherKey to firebase
      },
      onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
        if (payloadTransferUpdate.status == PayloadStatus.IN_PROGRESS) {
          print(payloadTransferUpdate.bytesTransferred);
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          print(endid + ": FAILED to transfer file");
        } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {
          print(
              "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");
        }
      },
    ).catchError((e) {
      print(e);
      return true;
    });
  }
}


//  ElevatedButton(
//               child: Text("Send Random Bytes Payload"),
//               onPressed: () async {
//                 endpointMap.forEach((key, value) {
//                   String a = Random().nextInt(100).toString();

//                   showSnackbar("Sending $a to ${value.endpointName}, id: $key");
//                   Nearby()
//                       .sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
//                 });
//               },
//             ),

// void onConnectionInit(String id, ConnectionInfo info) {
//     showModalBottomSheet(
//       context: context,
//       builder: (builder) {
//         return Center(
//           child: Column(
//             children: <Widget>[
//               Text("id: " + id),
//               Text("Token: " + info.authenticationToken),
//               Text("Name" + info.endpointName),
//               Text("Incoming: " + info.isIncomingConnection.toString()),
//               ElevatedButton(
//                 child: Text("Accept Connection"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   setState(() {
//                     endpointMap[id] = info;
//                   });
//                   Nearby().acceptConnection(
//                     id,
//                     onPayLoadRecieved: (endid, payload) async {
//                       if (payload.type == PayloadType.BYTES) {
//                         String str = String.fromCharCodes(payload.bytes!);
//                         showSnackbar(endid + ": " + str);

//                         if (str.contains(':')) {
//                           // used for file payload as file payload is mapped as
//                           // payloadId:filename
//                           int payloadId = int.parse(str.split(':')[0]);
//                           String fileName = (str.split(':')[1]);

//                           if (map.containsKey(payloadId)) {
//                             if (await tempFile!.exists()) {
//                               tempFile!.rename(
//                                   tempFile!.parent.path + "/" + fileName);
//                             } else {
//                               showSnackbar("File doesn't exist");
//                             }
//                           } else {
//                             //add to map if not already
//                             map[payloadId] = fileName;
//                           }
//                         }
//                       } else if (payload.type == PayloadType.FILE) {
//                         showSnackbar(endid + ": File transfer started");
//                         tempFile = File(payload.filePath!);
//                       }
//                     },
//                     onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
//                       if (payloadTransferUpdate.status ==
//                           PayloadStatus.IN_PROGRESS) {
//                         print(payloadTransferUpdate.bytesTransferred);
//                       } else if (payloadTransferUpdate.status ==
//                           PayloadStatus.FAILURE) {
//                         print("failed");
//                         showSnackbar(endid + ": FAILED to transfer file");
//                       } else if (payloadTransferUpdate.status ==
//                           PayloadStatus.SUCCESS) {
//                         showSnackbar(
//                             "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");

//                         if (map.containsKey(payloadTransferUpdate.id)) {
//                           //rename the file now
//                           String name = map[payloadTransferUpdate.id]!;
//                           tempFile!.rename(tempFile!.parent.path + "/" + name);
//                         } else {
//                           //bytes not received till yet
//                           map[payloadTransferUpdate.id] = "";
//                         }
//                       }
//                     },
//                   );
//                 },
//               ),
//               ElevatedButton(
//                 child: Text("Reject Connection"),
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   try {
//                     await Nearby().rejectConnection(id);
//                   } catch (e) {
//                     showSnackbar(e);
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
