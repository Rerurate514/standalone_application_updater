import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_progress.freezed.dart';

@freezed
sealed class DownloadProgress with _$DownloadProgress {
  const DownloadProgress._();
  
  const factory DownloadProgress({
    required int receivedBytes,
    required int totalBytes,
  }) = _DownloadProgress;

  double get percentage => (receivedBytes / totalBytes) * 100;
}
