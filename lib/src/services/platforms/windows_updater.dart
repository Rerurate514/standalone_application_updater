import 'dart:io';

import 'package:standalone_application_updater/src/domain/entities/update_check_result.dart';
import 'package:standalone_application_updater/src/services/interface/standalone_updater_interface.dart';

class WindowsUpdater extends IStandaloneUpdateBase {
  @override
  Future<void> downloadUpdate(UpdateCheckAvailable result) async {
  }

  @override
  Future<void> applyUpdate() async {
    if (Platform.isWindows) {
      // shell32.dll などを介してインストーラーを起動する処理
    }
  }
}
