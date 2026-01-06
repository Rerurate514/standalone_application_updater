import 'package:standalone_application_updater/src/domain/entities/download_update_result.dart';
import 'package:standalone_application_updater/src/domain/entities/update_check_result.dart';

abstract class IDownloadUpdateService {
  Future<DownloadUpdateResult> downloadUpdate(UpdateCheckAvailable result);
}
