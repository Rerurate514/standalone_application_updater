import 'dart:io';

import 'package:standalone_application_updater/src/services/platforms/windows_updater.dart';
import 'package:standalone_application_updater/src/services/interface/standalone_updater_interface.dart';

IStandaloneUpdateBase getUpdater() {
  if (Platform.isWindows) return WindowsUpdater();
  // if (Platform.isMacOS) return MacOSUpdater();
  throw UnimplementedError();
}
