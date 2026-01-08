import 'dart:io';

import 'package:standalone_application_updater/src/domain/interfaces/standalone_updater_interface.dart';
import 'package:standalone_application_updater/src/domain/services/apply_update_service.dart';
import 'package:standalone_application_updater/src/infrastructure/repositories/archive_repository.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';
import 'package:standalone_application_updater/standalone_application_updater.dart';

class WindowsUpdater extends IStandaloneUpdateBase with MyLogger {
  @override
  Future<bool> applyUpdate(IDownloadSuccess result, SauConfig config) async {
    if (!Platform.isWindows) throw UnsupportedError("WindowsUpdater was called on a non-Windows platform");

    final ar = ArchiveRepository();
    final aus = ApplyUpdateService(ar: ar);
    
    return await aus.applyUpdate(result, config);
  }
}
