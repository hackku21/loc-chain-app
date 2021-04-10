import 'package:fast_rsa/model/bridge.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fast_rsa/rsa.dart';
import 'package:dbcrypt/dbcrypt.dart';

import 'package:loc_chain_app/util/keyfile_manager.dart';

import 'dart:io';

class Transaction {
  Transaction({required this.hash, required this.pubKey});
  final String hash;
  final String pubKey;

  static Future<String> generateHash(String otherUserId) async {
    String id = await SharedPreferences.getInstance()
        .then((s) => s.getString('userName') ?? '');
    bool idLess = id.compareTo(otherUserId) < 0;
    var lesser = idLess ? id : otherUserId;
    var greater = idLess ? otherUserId : id;
    return DBCrypt()
        .hashpw("$lesser-$greater", KeyFileManager.keyPair.privateKey);
  }

  Future<String> generateP2PPayload(String otherUserId) async =>
      "${await generateHash(otherUserId)}:${KeyFileManager.keyPair.publicKey}";
}

class TransactionsDBManager {
  static Future<Database> get _localFile async {
    return openDatabase('transactions.db');
  }

  static Future<List<Transaction>?> readTransactions() async {}

  static Future<void> writeKeyPair(KeyPair pair) async {}
}
