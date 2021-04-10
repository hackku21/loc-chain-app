import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fast_rsa/rsa.dart';
import 'package:fast_rsa/model/bridge.pb.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

class KeyFileManager {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _pubKeyFile async {
    final path = await _localPath;
    return File('$path/rsa.pub');
  }

  static Future<File> get _privKeyFile async {
    final path = await _localPath;
    return File('$path/rsa');
  }

  static Future<KeyPair> readKeyPair() async {
    try {
      String privKey = await _privKeyFile.then(
        (file) => file.readAsString(),
      );
      String pubKey = await _pubKeyFile.then(
        (file) => file.readAsString(),
      );

      return KeyPair(
        privateKey: privKey,
        publicKey: pubKey,
      );
    } catch (e) {
      print(e);
      return KeyPair();
    }
  }

  static Future<void> writeKeyPair(KeyPair pair) async {
    final File privKeyFile = await _privKeyFile;
    final File pubKeyFile = await _pubKeyFile;
    pubKeyFile.writeAsString(pair.publicKey);
    privKeyFile.writeAsString(pair.privateKey);
  }
}

class KeygenPage extends StatefulWidget {
  KeygenPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _KeygenState createState() => _KeygenState();
}

class _KeygenState extends State<KeygenPage> {
  KeyPair _keyPair = KeyPair();

  @override
  void initState() {
    super.initState();
    KeyFileManager.readKeyPair().then((keyPair) {
      if (!keyPair.hasPublicKey()) {
        initKeyPair();
      } else {
        setState(() => _keyPair = keyPair);
      }
    });
  }

  Future<void> initKeyPair() async {
    var keyPair = await RSA.generate(2048);
    await KeyFileManager.writeKeyPair(keyPair);
    setState(() {
      _keyPair = keyPair;
    });
  }

  void copyPublicKey() {
    if (_keyPair.hasPublicKey()) {
      Clipboard.setData(
        new ClipboardData(
          text: _keyPair.publicKey,
        ),
      ).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("RSA public key copied to keyboard"),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You need to generate an RSA keypair before copying."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RSA Key Configuration'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(32),
                  child: TextButton(
                    onPressed: copyPublicKey,
                    child: Text(
                      _keyPair.publicKey,
                      style: Theme.of(context).textTheme.bodyText1,
                      softWrap: true,
                    ),
                    style: Theme.of(context).outlinedButtonTheme.style,
                  ),
                ),
                ElevatedButton(
                  onPressed: initKeyPair,
                  child: Text('Reset RSA Key'),
                  style: Theme.of(context).elevatedButtonTheme.style,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
