import 'package:standalone_application_updater/src/domain/entities/repository_info.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_config.dart';

abstract class IStandaloneUpdateBase {
  Future<bool> checkForUpdates(RepositoryInfo repoInfo, SAUConfig config);
  Future<void> downloadUpdate();
  Future<void> applyUpdate();
}
