import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_release.dart';
import 'package:standalone_application_updater/src/domain/entities/version.dart';

part 'update_check_result.freezed.dart';

@freezed
sealed class UpdateCheckResult with _$UpdateCheckResult {
  const factory UpdateCheckResult({
    required bool hasUpdate,
    SauRelease? latestRelease,
    Version? currentVersion,
  }) = _UpdateCheckResult;

  factory UpdateCheckResult.createFailure() {
    return UpdateCheckResult(hasUpdate: false);
  }
}
