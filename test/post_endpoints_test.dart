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

  group('POST endpoints', () {
   
    test('reportArticle failure', () async {
      const articleId = 1;
      const reportText = 'This article is inappropriate.';
      dioAdapter.onPost('/api/article/$articleId/report',
          (request) => request.reply(400, {'message': 'Bad request'}));

      expect(
        () async => await apiService.reportArticle(articleId, reportText),
        throwsException,
      );
    });

    test('reportProfile failure', () async {
      const nickname = 'testuser';
      const content = 'This profile is inappropriate.';
      dioAdapter.onPost('/api/profile/$nickname/report',
          (request) => request.reply(400, {'message': 'Bad request'}));

      expect(
        () async => await apiService.reportProfile(nickname, content),
        throwsException,
      );
    });

    test('likeArticle success', () async {
      const articleId = 1;
      dioAdapter.onPost('/api/article/$articleId/like',
          (request) => request.reply(200, {'message': 'Article liked'}));

      await apiService.likeArticle(articleId);
    });

    test('likeArticle already liked', () async {
      const articleId = 1;
      dioAdapter.onPost('/api/article/$articleId/like',
          (request) => request.reply(409, {'message': 'Article already liked'}));

      await apiService.likeArticle(articleId);
    });

    test('likeArticle failure', () async {
      const articleId = 1;
      dioAdapter.onPost('/api/article/$articleId/like',
          (request) => request.reply(500, {'message': 'Server error'}));

      expect(
        () async => await apiService.likeArticle(articleId),
        throwsException,
      );
    });

    test('addCommentToArticle failure', () async {
      const articleId = 1;
      const content = 'Great article!';
      dioAdapter.onPost('/api/article/$articleId/comment',
          (request) => request.reply(500, {'message': 'Server error'}));

      expect(
        () async => await apiService.addCommentToArticle(articleId, content),
        throwsException,
      );
    });

    test('subscribeToProfile success', () async {
      const nickname = 'testuser';
      dioAdapter.onPost('/api/profile/$nickname/subscribe',
          (request) => request.reply(200, {'message': 'Subscribed successfully'}));

      final response = await apiService.subscribeToProfil(nickname);
      expect(response.statusCode, 200);
    });

    test('subscribeToProfile failure', () async {
      const nickname = 'testuser';
      dioAdapter.onPost('/api/profile/$nickname/subscribe',
          (request) => request.reply(500, {'message': 'Server error'}));

      expect(
        () async => await apiService.subscribeToProfil(nickname),
        throwsException,
      );
    });

    test('reportComment failure', () async {
      const articleId = 1;
      const content = 'This comment is inappropriate.';
      dioAdapter.onPost('/api/article/$articleId/report',
          (request) => request.reply(400, {'message': 'Bad request'}));

      expect(
        () async => await apiService.reportComment(articleId, content),
        throwsException,
      );
    });

    test('createProfile failure', () async {
      const nickname = 'newUser';
      const description = 'This is a new user.';
      dioAdapter.onPost('/api/profile',
          (request) => request.reply(500, {'message': 'Server error'}));

      expect(
        () async => await apiService.createProfile(nickname: nickname, description: description),
        throwsException,
      );
    });
    test('createArticle failure', () async {
      const title = 'New Article';
      const body = 'This is a new article content.';
      const tags = ['tag1', 'tag2'];
      dioAdapter.onPost('/api/article',
          (request) => request.reply(500, {'message': 'Server error'}));

      expect(
        () async => await apiService.createArticle(
            title: title, body: body, tags: tags),
        throwsException,
      );
    });
  });
}
