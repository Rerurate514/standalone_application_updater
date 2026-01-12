import 'dart:io';

import 'package:standalone_application_updater/src/domain/entities/download_update_result.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_config.dart';
import 'package:standalone_application_updater/src/domain/interfaces/apply_update_service_interface.dart';
import 'package:standalone_application_updater/src/domain/interfaces/archive_repository_interface.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';
import 'package:path/path.dart' as p;


class WindowsApplyUpdateService extends IApplyUpdateService with MyLogger {
  final IArchiveRepository ar;

  WindowsApplyUpdateService({
    required this.ar
  });

  @override
  Future<bool> applyUpdate(IDownloadSuccess result, String entryPath, SauConfig config) async {
    final file = File(result.savePath);

    if (!await file.exists()) {
      errorf("ApplyUpdate Failed: The file does not exist at the specified path: ${result.savePath}", config.enableLogging);
      return false;
    }

    final zipFileName = p.withoutExtension(result.savePath);
    await _extractZip(result.savePath, zipFileName);

    try {
      infof("Attempting to start the update process: ${result.savePath}", config.enableLogging);

      final process = await Process.start(
        p.join(zipFileName, entryPath),
        [],
        mode: ProcessStartMode.detached,
      );

      infof("Successfully detached update process. PID: ${process.pid}", config.enableLogging);
      return true;
    } on ProcessException catch (e) {
      errorf("ApplyUpdate Failed (ProcessException): ${e.message}\n\nPath: ${e.executable}\nErrorCode: ${e.errorCode}", config.enableLogging);
      return false;
    } catch (e) {
      errorf("ApplyUpdate Failed (Unknown Error): $e", config.enableLogging);
      return false;
    }
  }

  Future<void> _extractZip(String zipFilePath, String destinationDirPath) async {
    await ar.extractZipFile(zipFilePath, destinationDirPath);
  }
}
