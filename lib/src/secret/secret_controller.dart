import 'package:flutter_keychain/flutter_keychain.dart';

class SecretController {
  Future<void> save(String key, String value) async {
    await FlutterKeychain.put(key: key, value: value);
  }

  Future<String?> get(String key) async {
    return await FlutterKeychain.get(key: key);
  }

  Future<void> reset() async {
    await FlutterKeychain.clear();
  }
}
