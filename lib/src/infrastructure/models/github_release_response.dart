import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_release_response.freezed.dart';
part 'github_release_response.g.dart';

@freezed
sealed class GithubReleaseResponse with _$GithubReleaseResponse {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GithubReleaseResponse({
    required String url,
    required String assetsUrl,
    required String uploadUrl,
    required String htmlUrl,
    required int id,
    required GithubAuthor author,
    required String nodeId,
    required String tagName,
    required String targetCommitish,
    required String name,
    required bool draft,
    required bool prerelease,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime publishedAt,
    required List<GithubAsset> assets,
    required String tarballUrl,
    required String zipballUrl,
    String? body,
  }) = _GithubReleaseResponse;

  factory GithubReleaseResponse.fromJson(Map<String, dynamic> json) => _$GithubReleaseResponseFromJson(json);
}

@freezed
sealed class GithubAuthor with _$GithubAuthor {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GithubAuthor({
    required String login,
    required int id,
    required String avatarUrl,
    required String url,
    required String htmlUrl,
    required String type,
    required bool siteAdmin,
  }) = _GithubAuthor;

  factory GithubAuthor.fromJson(Map<String, dynamic> json) => _$GithubAuthorFromJson(json);
}

@freezed
sealed class GithubAsset with _$GithubAsset {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GithubAsset({
    required String url,
    required int id,
    required String name,
    String? label,
    required GithubAuthor uploader,
    required String contentType,
    required String state,
    required int size,
    required int downloadCount,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String browserDownloadUrl,
  }) = _GithubAsset;

  factory GithubAsset.fromJson(Map<String, dynamic> json) => _$GithubAssetFromJson(json);
}
