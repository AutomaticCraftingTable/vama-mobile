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

  group('DELETE endpoints', () {
    test('unlikeArticle success', () async {
      const articleId = 1;
      dioAdapter.onDelete('/api/article/$articleId/like',
          (request) => request.reply(200, null));

      await apiService.unlikeArticle(articleId);
    });

    test('unlikeArticle like not found', () async {
      const articleId = 2;
      dioAdapter.onDelete('/api/article/$articleId/like',
          (request) => request.reply(404, {'message': 'Like not found'}));

      await apiService.unlikeArticle(articleId);
    });

    test('unsubscribeFromProfile success', () async {
      const nickname = 'user123';
      dioAdapter.onDelete('/api/profile/$nickname/subscribe',
          (request) => request.reply(200, {}));

      final response = await apiService.unsubscribeFromProfile(nickname);
      expect(response.statusCode, 200);
    });

    test('deleteComment success', () async {
      const commentId = 10;
      dioAdapter.onDelete('/api/comment/$commentId',
          (request) => request.reply(200, {}));

      await apiService.deleteComment(commentId);
    });

    test('deleteComment failure', () async {
      const commentId = 11;
      dioAdapter.onDelete('/api/comment/$commentId',
          (request) => request.reply(500, {}));

      expect(
        () async => await apiService.deleteComment(commentId),
        throwsException,
      );
    });

    test('deleteProfile success 204', () async {
      dioAdapter.onDelete('/api/profile',
          (request) => request.reply(204, null));

      await apiService.deleteProfile();
    });

    test('deleteProfile failure', () async {
      dioAdapter.onDelete('/api/profile',
          (request) => request.reply(500, null));

      expect(() async => await apiService.deleteProfile(), throwsException);
    });

    test('deleteAccount success 204', () async {
      dioAdapter.onDelete('/api/account',
          (request) => request.reply(204, null));

      await apiService.deleteAccount();
    });

    test('deleteAccount failure', () async {
      dioAdapter.onDelete('/api/account',
          (request) => request.reply(500, null));

      expect(() async => await apiService.deleteAccount(), throwsException);
    });

    test('deleteArticle success', () async {
      const articleId = 100;
      dioAdapter.onDelete('/api/article/$articleId',
          (request) => request.reply(200, {'result': 'deleted'}));

      final response = await apiService.deleteArticle(articleId);
      expect(response.statusCode, 200);
    });
  });
}