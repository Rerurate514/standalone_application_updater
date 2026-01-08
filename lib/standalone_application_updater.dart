export 'src/domain/entities/sau_config.dart';
export 'src/domain/entities/repository_info.dart';
export 'src/domain/entities/sau_release.dart';
export 'src/domain/entities/sau_platform.dart';
export 'src/domain/entities/update_check_result.dart';
export 'src/domain/entities/download_update_result.dart';
export 'src/domain/entities/download_progress.dart';

import 'package:standalone_application_updater/src/domain/interfaces/standalone_updater_interface.dart';

import 'src/standalone_application_updater_stub.dart'
    if (dart.library.io) 'src/standalone_application_updater_io.dart';

class StandaloneApplicationUpdater {
  static IStandaloneUpdateBase get instance => getUpdater();
}
