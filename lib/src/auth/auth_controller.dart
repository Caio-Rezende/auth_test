import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthController {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> requestAuth() async {
    try {
      return await _auth.authenticate(
          localizedReason: 'Please authenticate to show account balance');
    } on PlatformException {
      return false;
    }
  }
}
