import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import '../utils/app_logger.dart';

abstract class BiometricAuthService {
  Future<bool> get isBiometricAvailable;
  Future<bool> authenticate({required String localizedReason});
  Future<List<BiometricType>> getAvailableBiometrics();
}

class BiometricAuthServiceImpl implements BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  Future<bool> get isBiometricAvailable async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException catch (e) {
      AppLogger.error('Error checking biometrics: $e',
          name: 'BiometricService');
      return false;
    }
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      AppLogger.error('Error getting available biometrics: $e',
          name: 'BiometricService');
      return [];
    }
  }

  @override
  Future<bool> authenticate({required String localizedReason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly:
              false, // Allow PIN/Pattern fallback if needed, or strictly secure?
          // Defaulting to false allows PIN which is good for UX. set to true for strict.
        ),
      );
    } on PlatformException catch (e) {
      AppLogger.error('Error during authentication: $e',
          name: 'BiometricService');
      return false;
    }
  }
}
