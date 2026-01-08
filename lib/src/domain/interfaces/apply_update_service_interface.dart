import 'package:standalone_application_updater/standalone_application_updater.dart';

abstract class IApplyUpdateService {
  Future<bool> applyUpdate(IDownloadSuccess result, SauConfig config);
}
