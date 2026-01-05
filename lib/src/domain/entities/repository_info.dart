import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_info.freezed.dart';

@freezed
sealed class RepositoryInfo with _$RepositoryInfo {
  const factory RepositoryInfo({
    required String owner,
    required String repoName
  }) = _RepositoryInfo;
}
