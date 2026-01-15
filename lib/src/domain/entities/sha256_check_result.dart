import 'package:freezed_annotation/freezed_annotation.dart';

part 'sha256_check_result.freezed.dart';

abstract interface class ISHA256DownloadSuccess {}

@freezed
sealed class SHA256CheckResult with _$SHA256CheckResult {
  @Implements<ISHA256DownloadSuccess>()
  factory SHA256CheckResult.valid() = SHA256CheckValid;
  @Implements<ISHA256DownloadSuccess>()
  factory SHA256CheckResult.invalid() = SHA256CheckInvalid;

  factory SHA256CheckResult.notExist() = SHA256CheckNotExist;

  factory SHA256CheckResult.failed() = SHA256CheckFailed;
}
