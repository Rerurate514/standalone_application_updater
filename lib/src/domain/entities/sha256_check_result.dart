import 'package:freezed_annotation/freezed_annotation.dart';

part 'sha256_check_result.freezed.dart';

abstract interface class IDownloadSuccess {}

@freezed
sealed class Sha256CheckResult with _$Sha256CheckResult {
  @Implements<IDownloadSuccess>()
  factory Sha256CheckResult.valid() = _Sha256CheckValid;
  @Implements<IDownloadSuccess>()
  factory Sha256CheckResult.invalid() = _Sha256CheckInvalid;

  factory Sha256CheckResult.notExist() = _Sha256CheckNotExist;

  factory Sha256CheckResult.failed() = _Sha256CheckFailed;
}
