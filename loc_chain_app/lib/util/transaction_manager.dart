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
