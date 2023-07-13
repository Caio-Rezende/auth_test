import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageController {
  final prefix = 'secret.app';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> save(String key, String value) async {
    try {
      await storage.write(key: '$prefix.$key', value: value);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> get(String key) async {
    try {
      return await storage.read(key: '$prefix.$key');
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<void> reset() async {
    try {
      await storage.deleteAll();
    } catch (e) {
      print(e);
    }
  }
}
