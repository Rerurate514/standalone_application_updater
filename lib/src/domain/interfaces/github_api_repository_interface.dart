import 'package:standalone_application_updater/src/domain/entities/repository_info.dart';
import 'package:standalone_application_updater/src/infrastructure/models/github_release_response.dart';

abstract class IGithubApiRepository {
  Future<GithubReleaseResponse?> fetchLatestRelease(RepositoryInfo info);
}
