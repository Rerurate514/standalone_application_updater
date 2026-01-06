import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:standalone_application_updater/src/domain/entities/download_progress.dart';

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

@freezed
sealed class DownloadUpdateStreamResult with _$DownloadUpdateStreamResult {
  // progress to download
  const factory DownloadUpdateStreamResult.progress({
    required DownloadProgress downloadProgress
  }) = DownloadUpdateStreamProgress;

  // download success
  const factory DownloadUpdateStreamResult.success({
    required String savePath,
  }) = DownloadUpdateStreamSuccess;

  // download failure
  const factory DownloadUpdateStreamResult.failure({
    required String message
  }) = DownloadUpdateStreamFailure;
}
