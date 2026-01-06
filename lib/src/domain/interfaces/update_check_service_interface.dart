import 'package:standalone_application_updater/src/domain/entities/repository_info.dart';
import 'package:standalone_application_updater/src/domain/entities/update_check_result.dart';

abstract class IUpdateCheckService {
  Future<UpdateCheckResult> checkForUpdates(RepositoryInfo info);
}
