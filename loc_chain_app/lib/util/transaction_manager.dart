import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:loc_chain_app/util/keyfile_manager.dart';

class Transaction {
  Transaction({required this.hash, required this.pubKey});
  final String hash;
  final String pubKey;

  static Future<String> generateHash(String otherUserId) async {
    String id = await FlutterUdid.consistentUdid;
    bool idLess = id.compareTo(otherUserId) < 0;
    var lesser = idLess ? id : otherUserId;
    var greater = idLess ? otherUserId : id;
    // return DBCrypt()
    //     .hashpw("$lesser-$greater", KeyFileManager.keyPair.privateKey);
    return "$lesser-$greater";
  }

  Future<String> generateP2PPayload(String otherUserId) async =>
      "${await generateHash(otherUserId)}:${KeyFileManager.keyPair.publicKey}";
}

class EncounterTransaction {
  EncounterTransaction({
    required this.combinedHash,
    required this.encodedGPSLocation,
    required this.partnerPublicKey,
    required this.validationSignature,
  }) : timestamp = "${DateTime.now().millisecondsSinceEpoch}";
  final String combinedHash;
  final String timestamp;
  final String encodedGPSLocation;
  final String partnerPublicKey;
  final String validationSignature;

  EncounterTransaction.fromJson(Map<String, dynamic> json)
      : combinedHash = json['combinedHash'],
        timestamp = json['timestamp'],
        encodedGPSLocation = json['encodedGPSLocation'],
        partnerPublicKey = json['partnerPublicKey'],
        validationSignature = json['validationSignature'];

  Map<String, dynamic> toJson() => {
        "combinedHash": combinedHash,
        "timestamp": timestamp,
        "encodedGPSLocation": encodedGPSLocation,
        "partnerPublicKey": partnerPublicKey,
        "validationSignature": validationSignature,
      };
}

class ExposureTransaction {
  final String clientID;
  final String timestamp;

  ExposureTransaction({
    required this.clientID,
  }) : timestamp = "${DateTime.now().millisecondsSinceEpoch}";

  ExposureTransaction.fromJson(Map<String, dynamic> json)
      : clientID = json['clientID'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
        "clientID": clientID,
        "timestamp": timestamp,
      };
}
