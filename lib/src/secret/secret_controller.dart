import 'package:flutter_keychain/flutter_keychain.dart';

class SecretController {
  Future<void> save(String key, String value) async {
    try {
      await FlutterKeychain.put(key: key, value: value);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> get(String key) async {
    try {
      return await FlutterKeychain.get(key: key);
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<void> reset() async {
    try {
      await FlutterKeychain.clear();
    } catch (e) {
      print(e);
    }
  }
}
