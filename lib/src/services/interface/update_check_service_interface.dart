import 'package:standalone_application_updater/src/domain/entities/repository_info.dart';

abstract class IUpdateCheckService {
  Future<bool> checkForUpdates(RepositoryInfo info);
}
