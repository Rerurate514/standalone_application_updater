import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_config.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_release.dart';
import 'package:standalone_application_updater/src/domain/entities/sha256_check_result.dart';
import 'package:standalone_application_updater/src/domain/interfaces/crypto_repository_interface.dart';
import 'package:standalone_application_updater/src/domain/interfaces/sha256_check_service_interface.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';

class SHA256CheckService extends ISHA256CheckService with MyLogger {
  final Dio dio;
  final ICryptoRepository cr;
  final SauConfig config;

  SHA256CheckService({
    required this.dio,
    required this.cr,
    required this.config
  });
  
  @override
  Future<SHA256CheckResult> checkSHA256(List<SauAsset> assets, SauAsset target, String savePath) async {
    final targetSHA256Name = "${target.name}.sha256";
    final targetSHA256Path = "$savePath.sha256";

    final SauAsset? targetSHA256 = assets.firstWhereOrNull(
      (asset) => asset.name == targetSHA256Name
    );

    if(targetSHA256 == null) return SHA256CheckResult.notExist();

    final response = await _executeDownload(
      targetSHA256.downloadUrl, 
      targetSHA256Path, 
      config
    );

    if(response == null) return SHA256CheckResult.failed();

    final isvalid = await cr.verifyFileHash(
      savePath,
      targetSHA256Path
    );

    if(isvalid) {
      return SHA256CheckResult.valid();
    } else {
      return SHA256CheckResult.invalid();
    }
  }

  Future<Response?> _executeDownload(
    String downloadUrl, 
    String savePath, 
    SauConfig config,
  ) async {
    try{
      final response = await dio.download(
        downloadUrl,
        savePath,
      );

      return response;
    } catch(e) {
      warningf(e, config.enableLogging);
    }

    return null;
  }
}
