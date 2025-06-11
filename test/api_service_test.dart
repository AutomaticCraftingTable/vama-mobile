// test/api_service_test.dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:vama_mobile/api/api_service.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late ApiService api;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://test.server'));
    dioAdapter = DioAdapter(dio: dio);
    api = ApiService();
    api.dio.httpClientAdapter = dioAdapter;
  });

  test('fetchSubscriptions  500', () async {
    dioAdapter.onGet(
      '/api/subscriptions',
      (server) => server.reply(500, {'error': 'server error'}),
    );

    expect(
      () async => await api.fetchSubscriptions(),
      throwsA(isA<DioError>()),
    );
  });

  test('fetchSubscriptions  401 Unauthorized', () async {
    dioAdapter.onGet(
      '/api/subscriptions',
      (server) => server.reply(401, {'message': 'unauthorized'}),
    );

    expect(
      () async => await api.fetchSubscriptions(),
      throwsA(isA<DioError>()),
    );
  });
 test('fetchSubscriptions', () async {
  dioAdapter.onGet(
    '/api/subscriptions',
    (server) => server.reply(200, {'unexpected': 'structure'}),
  );

  expect(() async => await api.fetchSubscriptions(), throwsException);
});

}
