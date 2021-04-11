import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp/model/bridge.pb.dart';

import 'package:loc_chain_app/util/keyfile_manager.dart';

class KeygenPage extends StatefulWidget {
  KeygenPage({Key? key, required this.title}) : super(key: key);
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
        setState(() {
          _keyPair.publicKey = keyPair.publicKey;
          _keyPair.privateKey = keyPair.privateKey;
        });
      }
    });
  }

  Future<void> initKeyPair() async {
    var options = KeyOptions()..rsaBits = 2048;
    var keyPair =
        await OpenPGP.generate(options: Options()..keyOptions = options);
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
        title: Text('PGP Key Configuration'),
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
                  child: Text('Reset PGP Key'),
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
