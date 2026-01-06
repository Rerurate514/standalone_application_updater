import 'package:dio/dio.dart';
import 'package:standalone_application_updater/src/domain/entities/repository_info.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_config.dart';
import 'package:standalone_application_updater/src/domain/entities/update_check_result.dart';
import 'package:standalone_application_updater/src/infrastructure/repositories/github_api_repository.dart';
import 'package:standalone_application_updater/src/infrastructure/repositories/package_info_repository.dart';
import 'package:standalone_application_updater/src/domain/services/update_check_service.dart';

abstract class IStandaloneUpdateBase {
  Future<UpdateCheckResult> checkForUpdates(RepositoryInfo repoInfo, SAUConfig config) async {
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
  Future<void> downloadUpdate(UpdateCheckAvailable result);
  Future<void> applyUpdate();
}
