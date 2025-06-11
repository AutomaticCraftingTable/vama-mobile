import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:vama_mobile/api/api_service.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late ApiService apiService;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://146.59.34.168:63851'));
    dioAdapter = DioAdapter(dio: dio);
    apiService = ApiService();
    apiService.dio = dio;
  });

  group('PATCH /api/account - changeAccountSettings', () {
    test('changeAccountSettings succeeds with email and password', () async {
      dioAdapter.onPatch(
        '/api/account',
        data: {
          'email': 'new@example.com',
          'oldPassword': 'old123',
          'newPassword': 'new456'
        },
        (request) => request.reply(200, {'message': 'Updated'}),
      );

      await apiService.changeAccountSettings(
        email: 'new@example.com',
        oldPassword: 'old123',
        newPassword: 'new456',
      );
    });

    test('changeAccountSettings succeeds with email only', () async {
      dioAdapter.onPatch(
        '/api/account',
        data: {'email': 'email@example.com'},
        (request) => request.reply(200, {'message': 'Email updated'}),
      );

      await apiService.changeAccountSettings(
        email: 'email@example.com',
        oldPassword: '',
        newPassword: '',
      );
    });

    test('changeAccountSettings throws exception on error', () async {
      dioAdapter.onPatch(
        '/api/account',
        data: {'email': 'fail@example.com'},
        (request) => request.reply(400, {'error': 'Bad request'}),
      );

      expect(
        () => apiService.changeAccountSettings(
          email: 'fail@example.com',
          oldPassword: '',
          newPassword: '',
        ),
        throwsException,
      );
    });
  });

  group('PUT /api/profile - changeProfileSettings', () {
    test('changeProfileSettings succeeds', () async {
      dioAdapter.onPut(
        '/api/profile',
        data: {'nickname': 'newNick', 'description': 'New desc'},
        (request) => request.reply(200, {'message': 'Profile updated'}),
      );

      await apiService.changeProfileSettings(
        nickname: 'newNick',
        description: 'New desc',
      );
    });

    test('changeProfileSettings throws exception on error', () async {
      dioAdapter.onPut(
        '/api/profile',
        data: {'nickname': 'bad', 'description': 'fail'},
        (request) => request.reply(500, {'error': 'Server error'}),
      );

      expect(
        () => apiService.changeProfileSettings(
          nickname: 'bad',
          description: 'fail',
        ),
        throwsException,
      );
    });
  });
  test('changeAccountSettings succeeds with password only', () async {
  dioAdapter.onPatch(
    '/api/account',
    data: {
      'oldPassword': 'old123',
      'newPassword': 'new456',
    },
    (request) => request.reply(200, {'message': 'Password updated'}),
  );

  await apiService.changeAccountSettings(
    email: '',
    oldPassword: 'old123',
    newPassword: 'new456',
  );
});
  test('changeProfileSettings throws exception on invalid nickname', () async {
    dioAdapter.onPut(
      '/api/profile',
      data: {'nickname': '', 'description': 'Valid desc'},
      (request) => request.reply(400, {'error': 'Invalid nickname'}),
    );

    expect(
      () => apiService.changeProfileSettings(
        nickname: '',
        description: 'Valid desc',
      ),
      throwsException,
    );
  });
  test('changeProfileSettings throws exception on invalid description', () async {
    dioAdapter.onPut(
      '/api/profile',
      data: {'nickname': 'ValidNick', 'description': ''},
      (request) => request.reply(400, {'error': 'Invalid description'}),
    );

    expect(
      () => apiService.changeProfileSettings(
        nickname: 'ValidNick',
        description: '',
      ),
      throwsException,
    );
  });
  test('changeAccountSettings throws exception on invalid email', () async {
    dioAdapter.onPatch(
      '/api/account',
      data: {'email': 'invalid-email'},
      (request) => request.reply(400, {'error': 'Invalid email'}),
    );

    expect(
      () => apiService.changeAccountSettings(
        email: 'invalid-email',
        oldPassword: '',
        newPassword: '',
      ),
      throwsException,
    );
  });
  test('changeAccountSettings throws exception on invalid password', () async {
    dioAdapter.onPatch(
      '/api/account',
      data: {'oldPassword': 'short', 'newPassword': 'short'},
      (request) => request.reply(400, {'error': 'Password too short'}),
    );

    expect(
      () => apiService.changeAccountSettings(
        email: '',
        oldPassword: 'short',
        newPassword: 'short',
      ),
      throwsException,
    );
  });
  test('changeProfileSettings throws exception on server error', () async {
    dioAdapter.onPut(
      '/api/profile',
      data: {'nickname': 'ValidNick', 'description': 'Valid desc'},
      (request) => request.reply(500, {'error': 'Server error'}),
    );

    expect(
      () => apiService.changeProfileSettings(
        nickname: 'ValidNick',
        description: 'Valid desc',
      ),
      throwsException,
    );
  });
  test('changeAccountSettings does nothing when all fields are empty', () async {
  expect(
    () => apiService.changeAccountSettings(
      email: '',
      oldPassword: '',
      newPassword: '',
    ),
    throwsException,
  );
});
test('changeProfileSettings succeeds with only nickname', () async {
  dioAdapter.onPut(
    '/api/profile',
    data: {'nickname': 'NickOnly'},
    (request) => request.reply(200, {'message': 'Nickname updated'}),
  );

  await apiService.changeProfileSettings(
    nickname: 'NickOnly',
    description: '',
  );
});
test('changeProfileSettings throws when both fields are empty', () async {
  expect(
    () => apiService.changeProfileSettings(nickname: '', description: ''),
    throwsException,
  );
});
  test('changeAccountSettings throws when email is invalid', () async {
    dioAdapter.onPatch(
      '/api/account',
      data: {'email': 'invalid-email'},
      (request) => request.reply(400, {'error': 'Invalid email'}),
    );

    expect(
      () => apiService.changeAccountSettings(
        email: 'invalid-email',
        oldPassword: '',
        newPassword: '',
      ),
      throwsException,
    );
  });
  test('changeAccountSettings throws when old password is too short', () async {
    dioAdapter.onPatch(
      '/api/account',
      data: {'oldPassword': 'short', 'newPassword': 'newPass'},
      (request) => request.reply(400, {'error': 'Old password too short'}),
    );

    expect(
      () => apiService.changeAccountSettings(
        email: '',
        oldPassword: 'short',
        newPassword: 'newPass',
      ),
      throwsException,
    );
  });
}
