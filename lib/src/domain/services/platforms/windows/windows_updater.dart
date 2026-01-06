import 'dart:io';

import 'package:dio/dio.dart';
import 'package:standalone_application_updater/src/domain/entities/download_update_result.dart';
import 'package:standalone_application_updater/src/domain/entities/update_check_result.dart';
import 'package:standalone_application_updater/src/domain/interfaces/standalone_updater_interface.dart';
import 'package:standalone_application_updater/src/domain/services/download_update_serivce.dart';
import 'package:standalone_application_updater/standalone_application_updater.dart';

class WindowsUpdater extends IStandaloneUpdateBase {
  @override
  Future<DownloadUpdateResult> downloadUpdate(UpdateCheckAvailable result, SAUConfig config) async {
    final Dio dio = Dio();
    final dus = DownloadUpdateSerivce(
      dio: dio,
      config: config
    );

    return await dus.downloadUpdate(result);
  }

  @override
  Future<void> applyUpdate() async {
    if (Platform.isWindows) {
      // shell32.dll などを介してインストーラーを起動する処理
    }
  }
}
