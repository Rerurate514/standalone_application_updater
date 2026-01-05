import 'package:standalone_application_updater/src/domain/entities/repository_info.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_config.dart';
import 'package:standalone_application_updater/src/services/interface/standalone_updater_interface.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';

class StandaloneUpdateService extends IStandaloneUpdateBase with MyLogger {
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
  
  @override
  Future<bool> checkForUpdates(RepositoryInfo repoInfo, SAUConfig config) {
    // TODO: implement checkForUpdates
    throw UnimplementedError();
  }
}
