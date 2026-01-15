import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_config.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_release.dart';
import 'package:standalone_application_updater/src/domain/entities/sha256_check_result.dart';
import 'package:standalone_application_updater/src/domain/interfaces/crypto_repository_interface.dart';
import 'package:standalone_application_updater/src/domain/interfaces/sha256_check_service_interface.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';

class Sha256CheckService extends ISha256CheckService with MyLogger {
  final Dio dio;
  final ICryptoRepository cr;
  final SauConfig config;

  Sha256CheckService({
    required this.dio,
    required this.cr,
    required this.config
  });
  
  @override
  Future<Sha256CheckResult> checkSha256(List<SauAsset> assets, SauAsset target, String savePath) async {
    final targetSha256Name = "${target.name}.sha256";
    final targetSha256Path = "$savePath.sha256";

    final SauAsset? targetSha256 = assets.firstWhereOrNull(
      (asset) => asset.name == targetSha256Name
    );

    if(targetSha256 == null) return Sha256CheckResult.notExist();

    final response = await _executeDownload(
      targetSha256.downloadUrl, 
      targetSha256Path, 
      config
    );

    if(response == null) return Sha256CheckResult.failed();

    final isvalid = await cr.verifyFileHash(
      savePath,
      targetSha256Path
    );

    debug("$savePath, $targetSha256Path");

    if(isvalid) {
      return Sha256CheckResult.valid();
    } else {
      return Sha256CheckResult.invalid();
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
