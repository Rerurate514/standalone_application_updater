import 'dart:io';

import 'package:standalone_application_updater/src/domain/services/platforms/windows/windows_updater.dart';
import 'package:standalone_application_updater/src/domain/interfaces/standalone_updater_interface.dart';
import 'package:standalone_application_updater/src/utils/exceptions.dart';

IStandaloneUpdateBase getUpdater() {
  if (Platform.isWindows) return WindowsUpdater();
  // if (Platform.isMacOS) return MacOSUpdater();
  throw SauUnsupportedOSException.createException();
}
