import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:standalone_application_updater/src/domain/entities/download_progress.dart';

part 'download_update_result.freezed.dart';

abstract interface class IDownloadSuccess {
  String get savePath;
}

@freezed
sealed class DownloadUpdateResult with _$DownloadUpdateResult {
  const DownloadUpdateResult._();

  // download success
  @Implements<IDownloadSuccess>()
  const factory DownloadUpdateResult.success({
    required String savePath
  }) = DownloadUpdateSuccess;

  // download failure
  const factory DownloadUpdateResult.failure({
    required Exception exception
  }) = DownloadUpdateFailure;
}

@freezed
sealed class DownloadUpdateStreamResult with _$DownloadUpdateStreamResult {
  const DownloadUpdateStreamResult._();

  // progress to download
  const factory DownloadUpdateStreamResult.progress({
    required DownloadProgress downloadProgress
  }) = DownloadUpdateStreamProgress;

  // download success
  @Implements<IDownloadSuccess>()
  const factory DownloadUpdateStreamResult.success({
    required String savePath
  }) = DownloadUpdateStreamSuccess;

  // download failure
  const factory DownloadUpdateStreamResult.failure({
    required Exception exception
  }) = DownloadUpdateStreamFailure;
}
