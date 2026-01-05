import 'package:freezed_annotation/freezed_annotation.dart';

part 'version.freezed.dart';

@freezed
sealed class Version with _$Version {
  const Version._();

  const factory Version({
    required String value
  }) = _Version;

  String get normalized => value.replaceFirst('v', '').split('+')[0];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Version) return false;
    return normalized == other.normalized;
  }

  @override
  int get hashCode => normalized.hashCode;
}
