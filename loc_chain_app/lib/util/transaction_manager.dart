import 'package:fast_rsa/model/bridge.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fast_rsa/rsa.dart';

import 'dart:io';

class Transaction {
  Transaction({required this.otherUserID}) {
    SharedPreferences.getInstance().then((s) => _id = s.getString('id') ?? '0');
  }
  late final String _id;
  final String otherUserID;
  static Hash? makeTransactionHash() {}
}

class TransactionsDBManager {
  static Future<Database> get _localFile async {
    return openDatabase('transactions.db');
  }

  static Future<List<Transaction>?> readTransactions() async {}

  static Future<void> writeKeyPair(KeyPair pair) async {}
}
