import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Connect {
  final serviceId = "com.yourdomain.appname";
  final Strategy strategy = Strategy.P2P_STAR;
  late final _userName;

  Map<String, ConnectionInfo> endpointMap = Map();

  Connect() {
    SharedPreferences.getInstance()
        .then((s) => _userName = s.getString('userName') ?? '0');
  }

  void startConnect() async {
    // final prefs = await SharedPreferences.getInstance();
    // final userName = prefs.getString('userName') ?? " ";

    try {
      bool advertise = await Nearby().startAdvertising(
        _userName,
        strategy,
        onConnectionInitiated: (String id, ConnectionInfo info) {
          // Called whenever a discoverer requests connection
          //
          // onConnectionInit
        },
        onConnectionResult: (String id, Status status) {
          // Called when connection is accepted/rejected
          // if connection is accepted send the transaction
          //
          //
        },
        onDisconnected: (String id) {
          // Callled whenever a discoverer disconnects from advertiser
        },
        serviceId: serviceId, // uniquely identifies your app
      );

      bool discovery = await Nearby().startDiscovery(
        _userName,
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
