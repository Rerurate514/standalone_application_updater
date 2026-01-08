import 'package:standalone_application_updater/src/domain/entities/download_update_result.dart';
import 'package:standalone_application_updater/src/domain/entities/update_check_result.dart';

abstract class IDownloadUpdateService {
  Future<DownloadUpdateResult> downloadUpdate(
    UpdateCheckAvailable result, 
    void Function(int received, int total)? onProgress,
    {
      String? savePath, 
    }
  );
  Stream<DownloadUpdateStreamResult> downloadUpdateStream(
    UpdateCheckAvailable result,
    {
      String? savePath, 
    }
  );
}
