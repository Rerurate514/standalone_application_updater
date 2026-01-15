import 'package:standalone_application_updater/standalone_application_updater.dart';

abstract class ISHA256CheckService {
  Future<SHA256CheckResult> checkSHA256(List<SauAsset> assets, SauAsset target, String savePath);
}
