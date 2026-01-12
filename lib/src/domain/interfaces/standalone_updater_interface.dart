import 'package:dio/dio.dart';
import 'package:standalone_application_updater/src/domain/entities/download_update_result.dart';
import 'package:standalone_application_updater/src/domain/entities/repository_info.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_config.dart';
import 'package:standalone_application_updater/src/domain/entities/update_check_result.dart';
import 'package:standalone_application_updater/src/domain/services/download_update_serivce.dart';
import 'package:standalone_application_updater/src/infrastructure/repositories/github_api_repository.dart';
import 'package:standalone_application_updater/src/infrastructure/repositories/package_info_repository.dart';
import 'package:standalone_application_updater/src/domain/services/update_check_service.dart';

abstract class IStandaloneUpdateBase {
  Future<UpdateCheckResult> checkForUpdates(RepositoryInfo repoInfo, SauConfig config) async {
    final ucs = UpdateCheckService(
      config: config, 
      gar: GithubApiRepositoryImpl(
        dio: Dio(),
        config: config
      ), 
      pir: await PackageInfoRepository.init()
    );

    return await ucs.checkForUpdates(repoInfo);
  }

  Future<DownloadUpdateResult> downloadUpdate(
    UpdateCheckAvailable result, 
    SauConfig config, 
    { 
      void Function(int received, int total)? onProgress,
      String? savePath,
    }
  ) async {
    final Dio dio = Dio();
    final dus = DownloadUpdateSerivce(
      dio: dio,
      config: config
    );

    return await dus.downloadUpdate(result, onProgress, savePath: savePath);
  }

    Stream<DownloadUpdateStreamResult> downloadUpdateStream(
      UpdateCheckAvailable result, 
      SauConfig config,
      {
        String? savePath
      }
    ) async* {
    final Dio dio = Dio();
    final dus = DownloadUpdateSerivce(
      dio: dio,
      config: config
    );

    yield* dus.downloadUpdateStream(result, savePath: savePath);
  }

  Future<void> applyUpdate(IDownloadSuccess result, String entryPath, SauConfig config);
}
