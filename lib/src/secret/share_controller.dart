import 'package:auth_test/src/secret/secure_storage_controller.dart';
import 'package:pointycastle/export.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

class ShareController {
  final publicKeyStoreKey = 'public.key';
  final privateKeyStoreKey = 'private.key';

  final SecureStorageController _secureStorage = SecureStorageController();
  final _helper = RsaKeyHelper();

  RSAPublicKey? publicKey;
  RSAPrivateKey? privateKey;

  String sendMessage(String msg, String othersPublicKeyPEM) {
    final othersPublicKey = _helper.parsePublicKeyFromPem(othersPublicKeyPEM);
    return encrypt(msg, othersPublicKey);
  }

  Future<String> receiveMessage(String msg) async {
    await _initKeyPair();
    return decrypt(msg, privateKey!);
  }

  Future<String> getPublicKey() async {
    await _initKeyPair();
    return _helper.encodePublicKeyToPemPKCS1(publicKey!);
  }

  Future<String> getPrivateKey() async {
    await _initKeyPair();
    return _helper.encodePrivateKeyToPemPKCS1(privateKey!);
  }

  _initKeyPair() async {
    await _loadKeyPair();

    if (publicKey == null || privateKey == null) {
      final keyPair =
          await _helper.computeRSAKeyPair(_helper.getSecureRandom());
      publicKey = keyPair.publicKey as RSAPublicKey;
      privateKey = keyPair.privateKey as RSAPrivateKey;

      _saveKeyPair();
    }
  }

  _saveKeyPair() {
    _secureStorage.save(
        publicKeyStoreKey, _helper.encodePublicKeyToPemPKCS1(publicKey!));
    _secureStorage.save(
        privateKeyStoreKey, _helper.encodePrivateKeyToPemPKCS1(privateKey!));
  }

  _loadKeyPair() async {
    final storedPublicKey = await _secureStorage.get(publicKeyStoreKey);
    if (storedPublicKey != null) {
      publicKey = _helper.parsePublicKeyFromPem(storedPublicKey);
    }

    final storedPrivateKey = await _secureStorage.get(privateKeyStoreKey);
    if (storedPrivateKey != null) {
      privateKey = _helper.parsePrivateKeyFromPem(storedPrivateKey);
    }
  }
}
