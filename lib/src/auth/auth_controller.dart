import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthController {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> get hasBiometrics async => await _auth.canCheckBiometrics;

  Future<bool> requestAuth() async {
    try {
      final result = await _auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return result;
    } on PlatformException {
      return false;
    }
  }
}
