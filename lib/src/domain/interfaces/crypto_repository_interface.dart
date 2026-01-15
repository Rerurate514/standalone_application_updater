abstract class ICryptoRepository {
  Future<bool> verifyFileHash(String targetFilePath, String sha256FilePath);
}
