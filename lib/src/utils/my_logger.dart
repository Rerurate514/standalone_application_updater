import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
  ),
);

mixin MyLogger {
  void debug(dynamic message) {
    logger.d(message);
  }

  void info(dynamic message) {
    logger.i(message);
  }

  void warning(dynamic message) {
    logger.w(message);
  }

  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }

  void fatal(dynamic message) {
    logger.f(message);
  }

  void debugf(dynamic message, bool enableLogging) {
    if (enableLogging) debug(message);
  }

  void infof(dynamic message, bool enableLogging) {
    if (enableLogging) info(message);
  }

  void warningf(dynamic message, bool enableLogging) {
    if (enableLogging) warning(message);
  }

  void errorf(dynamic message, bool enableLogging, [dynamic error, StackTrace? stackTrace]) {
    if (enableLogging) this.error(message, error, stackTrace);
  }

  void fatalf(dynamic message, bool enableLogging) {
    if (enableLogging) fatal(message);
  }
}
