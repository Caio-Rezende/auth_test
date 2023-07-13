import 'dart:convert';

import 'package:auth_test/src/secret/secure_storage_controller.dart';
import 'package:pointycastle/export.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

class ShareController {
  final _publicKeyStoreKey = 'public.key';
  final _privateKeyStoreKey = 'private.key';

  final SecureStorageController _secureStorage = SecureStorageController();
  final _helper = RsaKeyHelper();

  RSAPublicKey? _publicKey;
  RSAPrivateKey? _privateKey;

  String sendMessage(String msg, String othersPublicKeyPEM) {
    final othersPublicKey = _helper.parsePublicKeyFromPem(othersPublicKeyPEM);
    final partial = encrypt(msg, othersPublicKey);

    final encoded = base64.encode(utf8.encode(partial));
    return encoded;
  }

  Future<String> receiveMessage(String msg) async {
    final decoded = utf8.decode(base64.decode(msg));

    await _initKeyPair();
    return decrypt(decoded, _privateKey!);
  }

  Future<String> getPublicKey() async {
    await _initKeyPair();
    return _helper.encodePublicKeyToPemPKCS1(_publicKey!);
  }

  Future<String> getPrivateKey() async {
    await _initKeyPair();
    return _helper.encodePrivateKeyToPemPKCS1(_privateKey!);
  }

  _initKeyPair() async {
    await _loadKeyPair();

    if (_publicKey == null || _privateKey == null) {
      final keyPair =
          await _helper.computeRSAKeyPair(_helper.getSecureRandom());
      _publicKey = keyPair.publicKey as RSAPublicKey;
      _privateKey = keyPair.privateKey as RSAPrivateKey;

      _saveKeyPair();
    }
  }

  _saveKeyPair() {
    _secureStorage.save(
        _publicKeyStoreKey, _helper.encodePublicKeyToPemPKCS1(_publicKey!));
    _secureStorage.save(
        _privateKeyStoreKey, _helper.encodePrivateKeyToPemPKCS1(_privateKey!));
  }

  _loadKeyPair() async {
    final storedPublicKey = await _secureStorage.get(_publicKeyStoreKey);
    if (storedPublicKey != null) {
      _publicKey = _helper.parsePublicKeyFromPem(storedPublicKey);
    }

    final storedPrivateKey = await _secureStorage.get(_privateKeyStoreKey);
    if (storedPrivateKey != null) {
      _privateKey = _helper.parsePrivateKeyFromPem(storedPrivateKey);
    }
  }
}
