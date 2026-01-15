import 'package:standalone_application_updater/src/domain/entities/sha256_check_result.dart';
import 'package:standalone_application_updater/standalone_application_updater.dart';

abstract class ISha256CheckService {
  Future<Sha256CheckResult> checkSha256(List<SauAsset> assets, SauAsset target, SauConfig config);
}
