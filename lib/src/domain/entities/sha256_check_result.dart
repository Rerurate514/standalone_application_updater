import 'package:freezed_annotation/freezed_annotation.dart';

part 'sha256_check_result.freezed.dart';

abstract interface class IDownloadSuccess {}

@freezed
sealed class Sha256CheckResult with _$Sha256CheckResult {
  @Implements<IDownloadSuccess>()
  factory Sha256CheckResult.valid() = Sha256CheckValid;
  @Implements<IDownloadSuccess>()
  factory Sha256CheckResult.invalid() = Sha256CheckInvalid;

  factory Sha256CheckResult.notExist() = Sha256CheckNotExist;

  factory Sha256CheckResult.failed() = Sha256CheckFailed;
}
