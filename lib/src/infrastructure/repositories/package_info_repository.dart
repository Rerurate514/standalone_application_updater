import 'package:standalone_application_updater/src/domain/interfaces/package_info_repository_interface.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoRepository extends IPackageInfoRepository {
  final PackageInfo _packageInfo;
  PackageInfoRepository(this._packageInfo);

  static Future<PackageInfoRepository> init() async {
    final info = await PackageInfo.fromPlatform();
    return PackageInfoRepository(info);
  }

  @override
  String get version => _packageInfo.version;
}
