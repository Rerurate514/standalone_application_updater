import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:standalone_application_updater/src/domain/interfaces/archive_repository_interface.dart';
import 'package:standalone_application_updater/src/utils/exceptions.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';

class ArchiveRepository extends IArchiveRepository with MyLogger {
  @override
  Future<void> extractZipFile(String zipFilePath, String destinationDirPath) async {
    try {
      final bytes = await File(zipFilePath).readAsBytes();

      final archive = ZipDecoder().decodeBytes(bytes);

      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final outputFilePath = p.join(destinationDirPath, filename);
          final outputFile = File(outputFilePath);
          
          await outputFile.parent.create(recursive: true);
          
          await outputFile.writeAsBytes(file.content as List<int>);
        } else {
          await Directory(p.join(destinationDirPath, filename)).create(recursive: true);
        }
      }
    } catch (e) {
      throw SauArchiveException.createException(e: e);
    }
  }
}
