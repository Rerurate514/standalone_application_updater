import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_update_result.freezed.dart';

@freezed
sealed class DownloadUpdateResult with _$DownloadUpdateResult {
  // download success
  const factory DownloadUpdateResult.success() = DownloadUpdateSuccess;

  // download failure
  const factory DownloadUpdateResult.failure({
    required String message
  }) = DownloadUpdateFailure;
}
