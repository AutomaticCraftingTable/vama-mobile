import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:provider/provider.dart';

import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/pages/subscriptions_page.dart';
import 'package:vama_mobile/provider/auth_provider.dart';

void main() {
  late ApiService api;
  late DioAdapter adapter;
  setUp(() {
    api = ApiService();
    adapter = DioAdapter(dio: api.dio);
    api.dio.httpClientAdapter = adapter;
  });
  Future<void> pumpTestWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(),
        child: MaterialApp(
          home: Subscriptions(),
        ),
      ),
    );
  }
  testWidgets('Masz blad 500', (tester) async {
    adapter.onGet(
      '/api/home/subscriptions',
      (server) => server.reply(500, {'error': 'err'}),
    );
    await pumpTestWidget(tester);
    await tester.pumpAndSettle();

    expect(find.textContaining('Błąd:'), findsOneWidget);
  });
}
