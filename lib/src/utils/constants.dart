class Constants {
  static String baseUrl = "https://api.github.com"; 

  static String sauDownloadException = "Failed to download : ";
  static String sauNotExistFileException = "The latest version source could not be obtained. This is likely because source compatible with the current OS (architecture) does not exist.";
  static String sauJsonDeserializationException = "Failed to deserialization : ";
  static String sauApiRequestException = "Failed to fetch : ";
  static String sauUnsupportedOSException = "unsupported os";
  static String sauHashMismatchException = "The downloaded file hash does not match. The file may be corrupted.";
  static String sauPermissionException = "Permission denied. Please run as administrator : ";
  static String sauArchiveException = "Failed to extract archive : ";
}
