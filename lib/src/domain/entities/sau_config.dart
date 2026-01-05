import 'package:freezed_annotation/freezed_annotation.dart';

part 'sau_config.freezed.dart';

@freezed
sealed class SAUConfig with _$SAUConfig {
  factory SAUConfig({
    @Default(false) bool enableLogging
  }) = _SAUConfig;
}
