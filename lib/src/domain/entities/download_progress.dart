import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:standalone_application_updater/src/domain/entities/download_update_result.dart';

part 'download_progress.freezed.dart';

@freezed
sealed class DownloadProgress with _$DownloadProgress {
  const factory DownloadProgress.downloading(double percentage) = Downloading;
  const factory DownloadProgress.completed(DownloadUpdateResult result) = DownloadCompleted;
}
