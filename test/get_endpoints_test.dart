import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dio/dio.dart';
import 'package:vama_mobile/api/api_service.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late ApiService apiService;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: "http://146.59.34.168:63851"));
    dioAdapter = DioAdapter(dio: dio);
    apiService = ApiService();
    apiService.dio = dio;
  });

  group('GET endpoints', () {
    test('fetchPosts returns articles list', () async {
      final mockData = {
        'articles': [
          {'id': 1, 'title': 'Article 1'},
          {'id': 2, 'title': 'Article 2'}
        ]
      };

      dioAdapter.onGet('/api/home', (request) => request.reply(200, mockData));

      final result = await apiService.fetchPosts();
      expect(result, isA<List<dynamic>>());
      expect(result.length, 2);
    });

    test('fetchArticle returns single article', () async {
      const articleId = 1;
      final mockData = {'id': 1, 'title': 'Test Article'};

      dioAdapter.onGet('/api/article/$articleId',
          (request) => request.reply(200, mockData));

      final result = await apiService.fetchArticle(articleId);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], 1);
    });

    test('fetchFavoriteArticles returns liked articles', () async {
      final mockData = {
        'articles': [
          {'id': 10, 'title': 'Liked Article'}
        ]
      };

      dioAdapter.onGet('/api/home/liked', (request) => request.reply(200, mockData));

      final result = await apiService.fetchFavoriteArticles();
      expect(result, isA<List<dynamic>>());
      expect(result.first['id'], 10);
    });

    test('fetchSubscriptions returns subscriptions', () async {
      final mockData = {
        'subscriptions': [
          {'nickname': 'user1'},
          {'nickname': 'user2'}
        ]
      };

      dioAdapter.onGet('/api/home/subscriptions', (request) => request.reply(200, mockData));

      final result = await apiService.fetchSubscriptions();
      expect(result, isA<List<dynamic>>());
      expect(result.length, 2);
    });

    test('fetchUserProfile returns user profile', () async {
      const nickname = 'testuser';
      final mockData = {'nickname': nickname, 'bio': 'Test bio'};

      dioAdapter.onGet('/api/profile/$nickname',
          (request) => request.reply(200, mockData));

      final result = await apiService.fetchUserProfile(nickname);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['nickname'], nickname);
    });

    test('fetchOwnProfile returns current user profile', () async {
      final mockData = {'nickname': 'me', 'bio': 'My bio'};

      dioAdapter.onGet('/api/profile', (request) => request.reply(200, mockData));

      final result = await apiService.fetchOwnProfile();
      expect(result, isA<Map<String, dynamic>>());
      expect(result['nickname'], 'me');
    });

    test('fetchPosts throws exception on error', () async {
  dioAdapter.onGet('/api/home', (request) => request.reply(500, {'message': 'Server error'}));

  expect(() async => await apiService.fetchPosts(), throwsException);
    });

    test('fetchFavoriteArticles handles empty response', () async {
  final mockData = {'articles': []};

  dioAdapter.onGet('/api/home/liked', (request) => request.reply(200, mockData));

  final result = await apiService.fetchFavoriteArticles();
  expect(result, isA<List<dynamic>>());
  expect(result.isEmpty, true);
});

  test('fetchArticle throws on 404', () async {
  dioAdapter.onGet('/api/article/999', (request) => request.reply(404, {'message': 'Not Found'}));

  expect(() async => await apiService.fetchArticle(999), throwsException);
});

  });
}
