import 'package:freezed_annotation/freezed_annotation.dart';

part 'sau_config.freezed.dart';

@freezed
sealed class SauConfig with _$SauConfig {
  factory SauConfig({
    @Default(false) bool enableLogging,
  }) = _SauConfig;
}
