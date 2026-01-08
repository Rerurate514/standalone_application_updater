abstract class IArchiveRepository {
  Future<void> extractZipFile(String zipFilePath, String destinationDirPath);
}
