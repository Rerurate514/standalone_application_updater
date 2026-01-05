import 'package:dio/dio.dart';
import 'package:standalone_application_updater/src/domain/entities/repository_info.dart';
import 'package:standalone_application_updater/src/domain/interfaces/github_api_repository_interface.dart';
import 'package:standalone_application_updater/src/infrastructure/models/github_release_response.dart';
import 'package:standalone_application_updater/src/utils/constants.dart';
import 'package:standalone_application_updater/src/utils/my_logger.dart';

class GithubApiRepositoryImpl extends IGithubApiRepository with MyLogger {
  final Dio dio;

  GithubApiRepositoryImpl({
    required this.dio,
  });

  @override
  Future<GithubReleaseResponse?> fetchLatestRelease(RepositoryInfo info) async {
    final String url = '${Constants.baseUrl}/repos/${info.owner}/${info.repoName}/releases/latest';
    final response = await _executeRequest(url);
    
    if (response == null || response.data == null) return null;

    try {
      final release = GithubReleaseResponse.fromJson(response.data as Map<String, dynamic>);
      return release;
    } catch (e) {
      error('Deserialization Error: $e');
      return null;
    }
  }

  Future<Response?> _executeRequest(String url) async {
    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
      );

      return response;
    } catch (e) {
      error('API Request Error: $e');
      return null;
    }
  }
}
