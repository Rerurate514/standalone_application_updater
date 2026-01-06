import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:standalone_application_updater/src/domain/entities/version.dart';
import 'package:standalone_application_updater/src/infrastructure/models/github_release_response.dart';

part 'sau_release.freezed.dart';

@freezed
sealed class SauRelease with _$SauRelease {
  const factory SauRelease({
    required Version version,
    required DateTime releaseDate,
    required List<SauAsset> assets,
    String? releaseNotes,
  }) = _SauRelease;
}

@freezed
sealed class SauAsset with _$SauAsset {
  const factory SauAsset({
    required String name,
    required String downloadUrl,
    required int size,
  }) = _SauAsset;

  factory SauAsset.fromGithubAsset(GithubAsset gasset) {
    return SauAsset(
      name: gasset.name, 
      downloadUrl: gasset.browserDownloadUrl, 
      size: gasset.size
    );
  }
}

extension GithubAssetConvertToSauAsset on List<GithubAsset> {
  List<SauAsset> convertToSauAsset() {
    List<SauAsset> list = [];

    for (final asset in this) {
      list.add(
        SauAsset(
          name: asset.name, 
          downloadUrl: asset.browserDownloadUrl, 
          size: asset.size
        )
      );
    }

    return list;
  }
}
