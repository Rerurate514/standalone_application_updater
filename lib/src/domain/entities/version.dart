import 'package:freezed_annotation/freezed_annotation.dart';

part 'version.freezed.dart';

@freezed
sealed class Version with _$Version {
  const factory Version({
    required String value
  }) = _Version;
}
