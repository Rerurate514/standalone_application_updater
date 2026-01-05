import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:standalone_application_updater/src/domain/entities/repository_info.dart';
import 'package:standalone_application_updater/src/infrastructure/models/github_release_response.dart';
import 'package:standalone_application_updater/src/infrastructure/repositories/github_api_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'github_api_repository_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late GithubApiRepositoryImpl repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = GithubApiRepositoryImpl(dio: mockDio);
  });

  final tRepositoryInfo = RepositoryInfo(owner: 'owner', repoName: 'repo');
  const tUrl = 'https://api.github.com/repos/owner/repo/releases/latest';

  group('fetchLatestRelease', () {
    test('ステータスコード200の場合、GithubReleaseResponseを返すこと', () async {
      final responseData = {
        'url': 'https://...',
        'assets_url': 'https://...',
        'upload_url': 'https://...',
        'html_url': 'https://...',
        'id': 1,
        'author': {
          'login': 'user',
          'id': 1,
          'avatar_url': '...',
          'url': '...',
          'html_url': '...',
          'type': 'User',
          'site_admin': false,
        },
        'node_id': '...',
        'tag_name': 'v1.0.0',
        'target_commitish': 'main',
        'name': 'v1.0.0',
        'draft': false,
        'prerelease': false,
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-01T00:00:00Z',
        'published_at': '2023-01-01T00:00:00Z',
        'assets': [],
        'tarball_url': '...',
        'zipball_url': '...',
        'body': 'description',
      };

      when(mockDio.get(
        any,
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: tUrl),
          ));

      final result = await repository.fetchLatestRelease(tRepositoryInfo);

      expect(result, isA<GithubReleaseResponse>());
      expect(result?.tagName, 'v1.0.0');
      verify(mockDio.get(tUrl, options: anyNamed('options'))).called(1);
    });

    test('DioErrorが発生した場合、nullを返すこと', () async {
      when(mockDio.get(
        any,
        options: anyNamed('options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: tUrl),
        type: DioExceptionType.connectionTimeout,
      ));

      final result = await repository.fetchLatestRelease(tRepositoryInfo);

      expect(result, isNull);
    });

    test('レスポンス形式が不正な場合（デシリアライズ失敗）、nullを返すこと', () async {
      when(mockDio.get(
        any,
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: {'invalid_field': 'data'},
            statusCode: 200,
            requestOptions: RequestOptions(path: tUrl),
          ));

      final result = await repository.fetchLatestRelease(tRepositoryInfo);

      expect(result, isNull);
    });
  });
}

