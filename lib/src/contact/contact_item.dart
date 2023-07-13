import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:auth_test/src/secret/secure_storage_controller.dart';

class ContactItem {
  static String listKey = 'contacts';
  static String prefix = 'contact.item';

  String name;
  String publicKey;

  ContactItem({this.name = '', this.publicKey = ''});

  String get hash => md5.convert(utf8.encode(publicKey)).toString();

  ContactItem.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        publicKey = json['publicKey'];

  Map<String, dynamic> toJson() => {'name': name, 'publicKey': publicKey};

  toStorage() {
    SecureStorageController().save('$prefix.$hash', jsonEncode(toJson()));
  }

  static Future<ContactItem?> fromStorage(String hash) async {
    final stored = await SecureStorageController().get('$prefix.$hash');
    if (stored != null) {
      final obj = jsonDecode(stored);
      ContactItem item = ContactItem(
        name: obj['name'],
        publicKey: obj['publicKey'],
      );
      return item;
    }
    return null;
  }
}
