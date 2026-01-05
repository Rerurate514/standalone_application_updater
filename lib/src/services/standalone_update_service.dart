import 'package:dio/dio.dart';
import 'package:standalone_application_updater/src/domain/entities/repository_info.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_config.dart';
import 'package:standalone_application_updater/src/infrastructure/repositories/github_api_repository.dart';
import 'package:standalone_application_updater/src/infrastructure/repositories/package_info_repository.dart';
import 'package:standalone_application_updater/src/services/interface/standalone_updater_interface.dart';
import 'package:standalone_application_updater/src/services/update_check_service.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';

class StandaloneUpdateService extends IStandaloneUpdateBase with MyLogger {
  @override
  Future<bool> checkForUpdates(RepositoryInfo repoInfo, SAUConfig config) async {
    final ucs = UpdateCheckService(
      config: config, 
      gar: GithubApiRepositoryImpl(
        dio: Dio()
      ), 
      pir: await PackageInfoRepository.init()
    );

    return await ucs.checkForUpdates(repoInfo);
  }

  @override
  Future<void> downloadUpdate() async {
    // TODO: implement downloadUpdate
    throw UnimplementedError();
  }

  @override
  Future<void> applyUpdate() async {
    // TODO: implement applyUpdate
    throw UnimplementedError();
  }
}
