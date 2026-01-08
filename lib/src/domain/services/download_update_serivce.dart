import 'dart:async';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:standalone_application_updater/src/domain/interfaces/download_update_service_interface.dart';
import 'package:standalone_application_updater/src/utils/exceptions.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';
import 'package:standalone_application_updater/standalone_application_updater.dart';

class DownloadUpdateSerivce extends IDownloadUpdateService with MyLogger {
  final Dio dio;
  final SAUConfig config;

  DownloadUpdateSerivce({
    required this.dio,
    required this.config
  });

  @override
  Future<DownloadUpdateResult> downloadUpdate(
    UpdateCheckAvailable result, 
    void Function(int received, int total)? onProgress,
    {
      String? savePath,
    }
  ) async {
    final List<SauAsset> assets = result.latestRelease.assets;
    final sauPlatformFromApp = SauPlatform.current();
    
    final SauAsset? target = assets.firstWhereOrNull(
      (asset) => SauPlatform.fromFileName(asset.name) == sauPlatformFromApp,
    );

    if(target == null) throw SauNotExistFileException.createException();
  
    infof("Found Asset, Starting to download Asset...", config.enableLogging);

    final path = savePath != null ? p.join(savePath, target.name) : _getExecutableDirectory();
    final response = await _executeDownload(target.downloadUrl, path, onProgress, config);

    infof("status code: ${response?.statusCode}", config.enableLogging);

    if(response == null) throw SauDownloadException.createException();

    return DownloadUpdateResult.success();
  }

  Future<Response?> _executeDownload(
    String downloadUrl, 
    String savePath, 
    void Function(int received, int total)? onProgress,
    SAUConfig config,
  ) async {
    try{
      final response = await dio.download(
        downloadUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && config.enableLogging) {
            if(onProgress != null) onProgress(received, total);
            showProgress(received, total);
          }
        },
      );

      return response;
    } catch(e) {
      warningf(e, config.enableLogging);
    }

    return null;
  }
  
  @override
  Stream<DownloadUpdateStreamResult> downloadUpdateStream(
    UpdateCheckAvailable result, 
    {
      String? savePath
    }
  ) async* {
    final List<SauAsset> assets = result.latestRelease.assets;
    final sauPlatformFromApp = SauPlatform.current();
    
    final SauAsset? target = assets.firstWhereOrNull(
      (asset) => SauPlatform.fromFileName(asset.name) == sauPlatformFromApp,
    );

    if(target == null) throw SauNotExistFileException.createException();
  
    infof("Found Asset, Starting to download Asset...", config.enableLogging);

    final path = savePath != null ? p.join(savePath, target.name) : _getExecutableDirectory();
    final downloadResult = _executeDownloadStream(target.downloadUrl, path, config);

    yield* downloadResult;
  }

  Stream<DownloadUpdateStreamResult> _executeDownloadStream(
    String downloadUrl, 
    String savePath, 
    SAUConfig config,
  ) {
    final controller = StreamController<DownloadUpdateStreamResult>();

    () async {
      try {
        await dio.download(
          downloadUrl,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              if (config.enableLogging) showProgress(received, total);

              controller.add(
                DownloadUpdateStreamResult.progress(
                  downloadProgress: DownloadProgress(
                    receivedBytes: received, 
                    totalBytes: total
                  ),
                ),
              );
            }
          },
        );

        controller.add(DownloadUpdateStreamResult.success(savePath: savePath));
      } catch (e) {
        warningf(e, config.enableLogging);
        SauException exception;
        
        if (e.toString().contains('Access is denied')) {
          exception = SauPermissionException.createException(e: e);
        } else {
          exception = SauDownloadException.createException(e: e);
        }
        
        controller.add(DownloadUpdateStreamResult.failure(exception: exception));
      } finally {
        await controller.close();
      }
    }();

    return controller.stream;
  }

  String _getExecutableDirectory() {
    final executablePath = Platform.resolvedExecutable;
    final executableDir = p.dirname(executablePath);
    return executableDir;
  }
}
