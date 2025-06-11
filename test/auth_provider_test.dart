import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/provider/auth_provider.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late ApiService apiService;
  late AuthProvider authProvider;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://146.59.34.168:63851'));
    dioAdapter = DioAdapter(dio: dio);
    apiService = ApiService();
    apiService.dio = dio;

    authProvider = AuthProvider();
   
  });

  group('POST /api/auth/register', () {
    test('register returns true on success (201)', () async {
      dioAdapter.onPost(
        '/api/auth/register',
        data: {
          'email': 'test@example.com',
          'password': '123456',
          'password_confirmation': '123456',
        },
        (request) => request.reply(201, {'message': 'Created'}),
      );

      final result = await authProvider.register('test@example.com', '123456', '123456');
      expect(result, true);
    });

    test('register returns false on failure', () async {
      dioAdapter.onPost(
        '/api/auth/register',
        data: {
          'email': 'fail@example.com',
          'password': '123456',
          'password_confirmation': '123456',
        },
        (request) => request.reply(400, {'error': 'Invalid data'}),
      );

      final result = await authProvider.register('fail@example.com', '123456', '123456');
      expect(result, false);
    });
  });

  group('POST /api/auth/login', () {
    test('login returns true on success and sets token', () async {
      dioAdapter.onPost(
        '/api/auth/login',
        data: {'email': 'user@example.com', 'password': 'password123'},
        (request) => request.reply(200, {
          'token': 'mocked-token',
          'user': {'id': 42}
        }),
      );

      final result = await authProvider.login('user@example.com', 'password123');
      expect(result, true);
    });

    test('login returns false when token missing', () async {
      dioAdapter.onPost(
        '/api/auth/login',
        data: {'email': 'user@example.com', 'password': 'password123'},
        (request) => request.reply(200, {
          'user': {'id': 1}
        }),
      );

      final result = await authProvider.login('user@example.com', 'password123');
      expect(result, false);
    });

    test('login returns false on unauthorized', () async {
      dioAdapter.onPost(
        '/api/auth/login',
        data: {'email': 'bad@example.com', 'password': 'wrong'},
        (request) => request.reply(401, {'error': 'Unauthorized'}),
      );

      final result = await authProvider.login('bad@example.com', 'wrong');
      expect(result, false);
    });
  });

  group('POST /api/auth/logout', () {
    test('logout completes without exception', () async {
      dioAdapter.onPost('/api/auth/logout', (request) => request.reply(200, {}));

      authProvider.logOut();
      expect(authProvider.isLoggedIn, false);
    });

    test('logout handles error but resets login state', () async {
      dioAdapter.onPost('/api/auth/logout', (request) => request.reply(500, {}));

      authProvider.logOut(); 
      expect(authProvider.isLoggedIn, false);
    });
  });
}
