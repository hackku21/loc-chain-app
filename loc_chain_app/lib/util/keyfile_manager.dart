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
