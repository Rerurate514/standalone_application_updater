import 'dart:io';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:standalone_application_updater/src/domain/interfaces/crypto_repository_interface.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';
import 'package:standalone_application_updater/standalone_application_updater.dart';

class CryptoRepository extends ICryptoRepository with MyLogger {
  final SauConfig config;

  CryptoRepository({
    required this.config
  });

  @override
  Future<bool> verifyFileHash(String targetFilePath, String sha256FilePath) async {
    final file = File(targetFilePath);

    if(!await file.exists()) {
      warningf("SHA256 file is not exist in local. ::: $targetFilePath", config.enableLogging);
      return false;
    }

    final stream = file.openRead();
    final hash = await sha256.bind(stream).first;

    final actualHash = hash.toString();
    final expectedHash = await _extractHashFromFile(sha256FilePath);

    if(expectedHash == null) return false;
    
    return actualHash.toLowerCase() == expectedHash.toLowerCase();
  }

  Future<String?> _extractHashFromFile(String sha256FilePath) async {
    try {
      final file = File(sha256FilePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final content = utf8.decode(bytes, allowMalformed: true);

      final cleanContent = content.replaceAll(RegExp(r'[^a-fA-F0-9]'), '');

      final hashRegex = RegExp(r'[a-fA-F0-9]{64}');
      final match = hashRegex.firstMatch(cleanContent);

      final isvalid = match?.group(0);

      if (isvalid != null) {
        return isvalid;
      } else {
        warningf('Hash value not found in file. Raw content: $content', config.enableLogging);
        return null;
      }
    } catch (e, stackTrace) {
      warningf('Error verifying file hash, error: $e, stackTrace: $stackTrace', config.enableLogging);
      return null;
    }
  }
}
