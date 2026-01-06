// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';

import 'package:standalone_application_updater/src/domain/entities/download_update_result.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_platform.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_release.dart';
import 'package:standalone_application_updater/src/domain/entities/update_check_result.dart';
import 'package:standalone_application_updater/src/domain/interfaces/download_update_service_interface.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';
import 'package:standalone_application_updater/standalone_application_updater.dart';

class DownloadUpdateSerivce extends IDownloadUpdateService with MyLogger {
  final Dio dio;

  DownloadUpdateSerivce({
    required this.dio
  });

  @override
  Future<DownloadUpdateResult> downloadUpdate(UpdateCheckAvailable result, SAUConfig config) async {
    final List<SauAsset> assets = result.latestRelease.assets;
    final sauPlatformFromApp = SauPlatform.current();
    
    final SauAsset? target = assets.firstWhereOrNull(
      (asset) => SauPlatform.fromFileName(asset.name) == sauPlatformFromApp,
    );

    if(target == null) return DownloadUpdateFailure(message: "The latest version source could not be obtained. This is likely because source compatible with the current OS (architecture) does not exist.");
  
    infof("Found Asset, Starting to download Asset...", config.enableLogging);

    final response = await _executeDownload(target.downloadUrl, config);

    infof("status code: ${response?.statusCode}", config.enableLogging);

    return DownloadUpdateResult.success();
  }

  Future<Response?> _executeDownload(String downloadUrl, SAUConfig config) async {
    try{
      final response = await dio.download(
        downloadUrl,
        config.downloadPath
      );

      return response;
    } catch(e) {
      warningf(e, config.enableLogging);
    }

    return null;
  }
}
