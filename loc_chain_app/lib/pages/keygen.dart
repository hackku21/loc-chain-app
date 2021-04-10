import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart' as rsa;
import 'package:pointycastle/api.dart' as crypto;

class KeygenPage extends StatefulWidget {
  KeygenPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _KeygenState createState() => _KeygenState();
}

class _KeygenState extends State<KeygenPage> {
  static crypto.AsymmetricKeyPair _keyPair;

  void _regenerateKey() {
    setState(() {
      _keyPair = rsa.getRsaKeyPair(rsa.RsaKeyHelper().getSecureRandom());
    });
  }

  String _getPublicKey() {
    if (_keyPair == null)
      return 'Press the button below to generate your key pair!';
    return '${rsa.RsaKeyHelper().encodePublicKeyToPemPKCS1(_keyPair.publicKey)}';
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('RSA Key Configuration'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () => Clipboard.setData(
                new ClipboardData(
                  text: _getPublicKey(),
                ),
              ).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("RSA public key copied to keyboard"),
                ));
              }),
              child: Text(
                _getPublicKey(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              style: Theme.of(context).outlinedButtonTheme.style,
            ),
            ElevatedButton(
              onPressed: _regenerateKey,
              child: Text('Reset RSA Key'),
              style: Theme.of(context).elevatedButtonTheme.style,
            ),
          ],
        ),
      ),
    );
  }
}
