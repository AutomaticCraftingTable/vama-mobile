import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  late  Dio dio;
  late final Dio mockDio;


  void setToken(String token) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }

   ApiService._internal() {
     dio = Dio(BaseOptions(
      baseUrl: "http://146.59.34.168:63851",
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
    ));

    mockDio = Dio(BaseOptions(
      baseUrl: "http://10.0.2.2:3658/m1/829899-809617-default",
      headers: {"Content-Type": "application/json"},
    ));

    if (kDebugMode) {
      final logger = InterceptorsWrapper(
        onRequest: (options, handler) {
          print("\n====== REQUEST ======");
          print("${options.method} ${options.baseUrl}${options.path}");
          print("> DATA: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("====== RESPONSE ======");
          print("${response.statusCode} ${response.requestOptions.uri}");
          print("> DATA: ${response.data}");
          return handler.next(response);
        },
        onError: (error, handler) {
          print("====== ERROR ======");
          print("${error.response?.statusCode} ${error.requestOptions.uri}");
          print("> DATA: ${error.response?.data}");
          return handler.next(error);
        },
      );
      dio.interceptors.add(logger);
      mockDio.interceptors.add(logger);
    }
  }
  Future<List<dynamic>> fetchPosts() async {
    try {
      final response = await dio.get('/api/home');
      if (response.statusCode == 200) {
        return response.data['articles'];
      } else {
        throw Exception("Failed to load posts");
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
Future<Map<String, dynamic>> fetchArticle(int articleId) async {
  try {
    final response = await dio.get("/api/article/$articleId");
    if (response.statusCode != 200) {
      throw Exception("Failed to load article");
    }
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception("Invalid data format");
    }

    final Map<String, dynamic> articleData = Map<String, dynamic>.from(data);

    final likeField = articleData['likes'];
    articleData['likes'] = likeField is List ? likeField.length : (likeField as int? ?? 0);

    final rawComments = articleData['comments'] as List<dynamic>? ?? [];
    final normalizedComments = rawComments.map<Map<String, dynamic>>((raw) {
      final comment = Map<String, dynamic>.from(raw as Map);
      final causer = comment['causer'];
      final causerId = (causer is Map<String, dynamic>) ? causer['id'] as int? : null;

      comment['causer'] = {
        'account_id': causerId,
        'nickname': comment['causer']['nickname'] ?? 'Unknown',
        'logo': comment['logo'] ?? '',
      };

      return comment;
    }).toList();

    articleData['comments'] = normalizedComments;
    return articleData;
  } catch (e) {
    throw Exception("Error fetching article: $e");
  }
}


Future<void> reportArticle(int articleId, String reportText) async {
  try {
    final response = await dio.post(
      '/api/article/$articleId/report',
      data: { 'content': reportText },
    );
    final status = response.statusCode ?? 0;
    if (status >= 200 && status < 300) {
      print('Article reported successfully: ${response.data}');
      return;
    }
    throw Exception(
       'Failed to report article (${response.statusCode}): ${response.data}'
    );
  } catch (e) {
    print('Error reporting article: $e');
    rethrow;
  }
}
Future<void> reportProfile(String nickname, String content) async {
  try {
    final response = await dio.post(
      '/api/profile/$nickname/report',
      data: {
        'content': content, 
      },
    );
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
    print("Profile reported successfully");
    } else {
      throw Exception("Failed to report profile");
    }
  } catch (e) {
    print("Error reporting profile: $e");
    rethrow;
  }
}

Future<void> likeArticle(int articleId) async {
  try {
    final response = await dio.post('/api/article/$articleId/like');

    final status = response.statusCode ?? 0;
    if (status >= 200 && status < 300) {
      return;
    }

    if (status == 409 && response.data['message'] == 'Article already liked') {
      return;
    }

    throw Exception('Failed to like article: $status');
  } on DioException catch (e) {
    final status = e.response?.statusCode ?? -1;
    if (status == 409 &&
        e.response?.data['message'] == 'Article already liked') {
      return;
    }
    rethrow;
  }
}

Future<void> unlikeArticle(int articleId) async {
  try {
    final response = await dio.delete('/api/article/$articleId/like');
    final status = response.statusCode ?? -1;

    if (status >= 200 && status < 300) {
      return;
    }
    if (status == 404 &&
        response.data is Map<String, dynamic> &&
        response.data['message'] == 'Like not found') {
      return;
    }

    throw Exception('Failed to unlike article: HTTP $status');
  } on DioException catch (e) {
    final status = e.response?.statusCode ?? -1;
    final data = e.response?.data;
    if (status == 404 &&
        data is Map<String, dynamic> &&
        data['message'] == 'Like not found') {
      return;
    }
    rethrow;
  }
}
Future<Map<String, dynamic>> addCommentToArticle(int articleId, String content) async {
  final response = await dio.post(
    '/api/article/$articleId/comment',
    data: {'content': content},
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Failed to add comment');
  }
  print('Ответ от API: ${response.data}');
  return Map<String, dynamic>.from(response.data as Map);
}
Future<Response> subscribeToProfil(String nickmame) async {
  try {
    final response = await dio.post(
      '/api/profile/$nickmame/subscribe',
    );
    return response;
  } catch (e) {
    throw Exception('Failed to subscribe: $e');
    }
  }
  Future<Response> unsubscribeFromProfile(String nickmame) async {
  try {
    final response = await dio.delete(
      '/api/profile/$nickmame/subscribe',
    );
    return response;
  } catch (e) {
    throw Exception('Failed to unsubscribe: $e');
    }
  }

Future<void> reportComment(int articleId, String content) async {
  try {
    final response = await dio.post(
      '/api/article/$articleId/report',
      data: {
        'content': content,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Comment reported successfully");
    } else {
      throw Exception("Failed to report comment");
    }
  } catch (e) {
    print("Error reporting comment: $e");
    rethrow;
  }
}


Future<List<dynamic>> fetchFavoriteArticles() async {
  try {
    final response = await dio.get('/api/home/liked');

    if (response.statusCode == 200) {
      return response.data['articles']; 
    } else {
      throw Exception('Failed to load favorite articles');
    }
  } catch (e) {
    print("Error fetching favorite articles: $e");
    rethrow;
  }
}
Future<List<dynamic>> fetchSubscriptions() async {
  try {
    final response = await dio.get('/api/home/subscriptions');

    if (response.statusCode == 200) {
      return response.data['subscriptions'];
    } else {
      throw Exception('Failed to load subscriptions');
    }
  } catch (e) {
    print("Error fetching subscriptions: $e");
    rethrow;
  }
}
Future<void> deleteComment(int commentId) async {
  final response = await dio.delete('/api/comment/$commentId');
  if (response.statusCode != 200) {
    throw Exception('Failed to unlike comment');
  }
}
Future<void> createProfile({
    required String nickname,
    required String description,
  }) async {
    final data = {
      'nickname': nickname,
      'description': description,
    };
    final response = await dio.post(
      '/api/profile', 
      data: data,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create/update profile');
    }
  }

  Future<void> deleteProfile() async {
    final response = await dio.delete('/api/profile'); 
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete profile');
    }
  }

  Future<void> changeAccountSettings({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    final data = <String, dynamic>{};
    if (email.isNotEmpty) data['email'] = email;
    if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
      data['oldPassword'] = oldPassword;
      data['newPassword'] = newPassword;
    }

    final response = await dio.patch(
      '/api/account',
      data: data,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to change account settings');
    }
  }

  Future<void> deleteAccount() async {
    final response = await dio.delete('/api/account'); 
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete account');
    }
  }
  Future<void> changeProfileSettings({
    required String nickname,
    required String description,
  }) async {
    final data = <String, dynamic>{};
    if (nickname.isNotEmpty) data['nickname'] = nickname;
    if (description.isNotEmpty) data['description'] = description;
     {
    }
    try {
      final response = await dio.put(
        '/api/profile', 
        data: data,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
      print('Profile updated successfully');
    } catch (e) {
      throw Exception('Error while updating profile: $e');
    }
  }
Future<Map<String, dynamic>> fetchUserProfile(String nickname) async {
  try {
    final encodedUsername = Uri.encodeComponent(nickname);

    final response = await dio.get(
      '/api/profile/$nickname',
      queryParameters: {
        'username': encodedUsername,
      },
    );
    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load user profile, status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching user profile by username "$nickname": $e');
    rethrow;
  }
}
Future<Map<String, dynamic>> fetchOwnProfile() async {
  try {
    final response = await dio.get('/api/profile');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to load user profile");
    }
  } catch (e) {
    print("Error fetching user profile: $e");
    rethrow;
  }
}
 Future<Map<String, dynamic>> createArticle({
    required String title,
    required String body,
    required List<String> tags,
  }) async {
    try {
      final data = {
        'title': title,
        'content': body,
        if (tags.isNotEmpty) 'tags': tags.join(',')
      };
      final response = await dio.post(
        '/api/article',
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Failed to create article: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) print("Error in createArticle: $e");
      rethrow;
    }
  }
  Future<Response> deleteArticle(int articleId) async {
  final response = await dio.delete('/api/article/$articleId');
  return response;
}

}
