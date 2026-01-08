import 'package:standalone_application_updater/src/utils/constants.dart';

sealed class SauException implements Exception {
  final String message;
  SauException(this.message);
}

class SauDownloadException extends SauException {
  final int? statusCode;
  SauDownloadException(super.message, {this.statusCode});

  factory SauDownloadException.throwException({dynamic e}) {
    return SauDownloadException(Constants.sauDownloadException + e);
  }
}

class SauNotExistFileException extends SauException {
  SauNotExistFileException(super.message);

  factory SauNotExistFileException.throwException() {
    return SauNotExistFileException(Constants.sauNotExistFileException);
  }
}

class SauJsonDeserializationException extends SauException {
  SauJsonDeserializationException(super.message);

  factory SauJsonDeserializationException.throwException({dynamic e}) {
    return SauJsonDeserializationException(Constants.sauJsonDeserializationException + e);
  }
}

class SauApiRequestException extends SauException {
  SauApiRequestException(super.message);

  factory SauApiRequestException.throwException({dynamic e}) {
    return SauApiRequestException(Constants.sauApiRequestException + e);
  }
}

class SauUnsupportedOSException extends SauException {
  SauUnsupportedOSException(super.message);

  factory SauUnsupportedOSException.throwException() {
    return SauUnsupportedOSException(Constants.sauUnsupportedOSException);
  }
}
