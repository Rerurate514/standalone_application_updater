import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:standalone_application_updater/src/domain/entities/sau_release.dart';
import 'package:standalone_application_updater/src/domain/entities/version.dart';

part 'update_check_result.freezed.dart';

@freezed
sealed class UpdateCheckResult with _$UpdateCheckResult {
  // Found latest version
  const factory UpdateCheckResult.available({
    required SauRelease latestRelease,
    required Version currentVersion,
  }) = UpdateCheckAvailable;

  // Already latest version
  const factory UpdateCheckResult.upToDate({
    required Version currentVersion,
  }) = UpdateCheckUpToDate;

  // Error
  const factory UpdateCheckResult.error({
    required String message,
  }) = UpdateCheckError;
}
