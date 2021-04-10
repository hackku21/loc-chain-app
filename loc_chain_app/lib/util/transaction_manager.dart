import 'package:fast_rsa/model/bridge.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fast_rsa/rsa.dart';

import 'package:loc_chain_app/util/keyfile_manager.dart';

import 'dart:io';

class Transaction {
  Transaction({required this.hash}) {
    SharedPreferences.getInstance().then((s) => _id = s.getString('id') ?? '0');
  }
  late final String _id;
  final String hash;
  static Future<String> makeTransactionHash(String otherUserId) async {
    String id = await SharedPreferences.getInstance()
        .then((s) => s.getString('id') ?? '');
    bool idLess = id.compareTo(otherUserId) < 0;
    var lesser = idLess ? id : otherUserId;
    var greater = idLess ? otherUserId : id;
    return RSA.signPKCS1v15("$lesser-$greater", Hash.HASH_SHA256,
        KeyFileManager.keyPair.privateKey);
  }
}

class TransactionsDBManager {
  static Future<Database> get _localFile async {
    return openDatabase('transactions.db');
  }

  static Future<List<Transaction>?> readTransactions() async {}

  static Future<void> writeKeyPair(KeyPair pair) async {}
}
