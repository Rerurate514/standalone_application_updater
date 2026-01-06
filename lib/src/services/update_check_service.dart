import 'package:standalone_application_updater/src/domain/entities/repository_info.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_config.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_release.dart';
import 'package:standalone_application_updater/src/domain/entities/update_check_result.dart';
import 'package:standalone_application_updater/src/domain/entities/version.dart';
import 'package:standalone_application_updater/src/domain/interfaces/github_api_repository_interface.dart';
import 'package:standalone_application_updater/src/domain/interfaces/package_info_repository_interface.dart';
import 'package:standalone_application_updater/src/services/interface/update_check_service_interface.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';

class UpdateCheckService extends IUpdateCheckService with MyLogger {
  final SAUConfig config;
  final IGithubApiRepository gar;
  final IPackageInfoRepository pir;

  UpdateCheckService({
    required this.config,
    required this.gar,
    required this.pir,
  });

  @override
  Future<UpdateCheckResult> checkForUpdates(RepositoryInfo repoInfo) async {
    final response = await gar.fetchLatestRelease(repoInfo);
    if (response == null) return UpdateCheckResult.createFailure();

    final versionFromApi = Version(value: response.tagName);
    final versionFromApp = Version(value: pir.version);

    if (versionFromApi == versionFromApp) {
      infof('最新バージョンを使用中です: ${versionFromApp.value}', config.enableLogging);
      return UpdateCheckResult.createFailure();
    }

    infof('新しいアップデートが見つかりました: ${versionFromApi.value}', config.enableLogging);
    
    final latestRelease = SauRelease(
      version: versionFromApi, 
      releaseDate: response.publishedAt, 
      assets: response.assets.convertToSauAsset()
    );

    return UpdateCheckResult(
      hasUpdate: true,
      latestRelease: latestRelease,
      currentVersion: versionFromApp
    );
  }
}
