import 'package:standalone_application_updater/src/utils/constants.dart';

sealed class SauException implements Exception {
  final String message;
  SauException(this.message);

  @override
  String toString() => message;
}

class SauDownloadException extends SauException {
  final int? statusCode;
  SauDownloadException(super.message, {this.statusCode});

  factory SauDownloadException.createException({dynamic e}) {
    return SauDownloadException(Constants.sauDownloadException + e.toString());
  }
}

class SauNotExistFileException extends SauException {
  SauNotExistFileException(super.message);

  factory SauNotExistFileException.createException() {
    return SauNotExistFileException(Constants.sauNotExistFileException);
  }
}

class SauJsonDeserializationException extends SauException {
  SauJsonDeserializationException(super.message);

  factory SauJsonDeserializationException.createException({dynamic e}) {
    return SauJsonDeserializationException(Constants.sauJsonDeserializationException + e.toString());
  }
}

class SauApiRequestException extends SauException {
  final int? statusCode;
  SauApiRequestException(super.message, {this.statusCode});

  factory SauApiRequestException.createException({dynamic e, int? statusCode}) {
    return SauApiRequestException(
      Constants.sauApiRequestException + e.toString(),
      statusCode: statusCode,
    );
  }
}

class SauUnsupportedOSException extends SauException {
  SauUnsupportedOSException(super.message);

  factory SauUnsupportedOSException.createException() {
    return SauUnsupportedOSException(Constants.sauUnsupportedOSException);
  }
}

class SauHashMismatchException extends SauException {
  SauHashMismatchException(super.message);

  factory SauHashMismatchException.createException() {
    return SauHashMismatchException(Constants.sauHashMismatchException);
  }
}

class SauPermissionException extends SauException {
  SauPermissionException(super.message);

  factory SauPermissionException.createException({dynamic e}) {
    return SauPermissionException(Constants.sauPermissionException + e.toString());
  }
}

class SauArchiveException extends SauException {
  SauArchiveException(super.message);

  factory SauArchiveException.createException({dynamic e}) {
    return SauArchiveException(Constants.sauArchiveException + e.toString());
  }
}
