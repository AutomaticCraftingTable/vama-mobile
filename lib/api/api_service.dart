import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  late final Dio dio;

  ApiService._internal() {
    dio = Dio(BaseOptions(
      baseUrl: "http://10.0.2.2:3658/m1/829899-809617-default",
      headers: {"Content-Type": "application/json"},
    ));

    if (kDebugMode) {
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          print("\n==============================================");
          print("REQUEST ${options.method} ${options.uri}");
          print("> DATA: ${options.data}");
          print("> METHOD: ${options.method}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("RESPONSE ${response.statusCode} ${response.requestOptions.uri}");
          print("> DATA: ${response.data}");
          return handler.next(response);
        },
        onError: (error, handler) {
          print("ERROR ${error.response?.statusCode} ${error.requestOptions.uri}");
          print("> DATA: ${error.response?.data}");
          return handler.next(error);
        },
      ));
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
      if (response.statusCode == 200) {
        return response.data; 
      } else {
        throw Exception("Failed to load article");
      }
    } catch (e) {
      print("Error fetching article: $e");
      
      rethrow;
    }
  }
  Future<void> reportArticle(int articleId, String message) async {
  try {
    final response = await dio.post(
      '/api/article/$articleId/report', 
      data: {
        'message': message,
      },
    );

    if (response.statusCode == 200) {
      print("Article reported successfully");
    } else {
      throw Exception("Failed to report article");
    }
  } catch (e) {
    print("Error reporting article: $e");
    rethrow;
  }
}
Future<void> reportProfile(int accountId, String message) async {
  try {
    final response = await dio.post(
      '/api/profile/$accountId/report', 
      data: {
        'message': message,
      },
    );

    if (response.statusCode == 200) {
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
  final response = await dio.post('/api/article/$articleId/like');
  if (response.statusCode != 200) {
    throw Exception('Failed to like article');
  }
}

Future<void> unlikeArticle(int articleId) async {
  final response = await dio.delete('/api/article/$articleId/like');
  if (response.statusCode != 200) {
    throw Exception('Failed to unlike article');
  }
}
Future<void> addCommentToArticle(int articleId, String content) async {
  final response = await dio.post(
    '/api/article/$articleId/comment',
    data: {'content': content},
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Failed to add comment');
  }
}
Future<Response> subscribeToProfil(int nickmame) async {
  try {
    final response = await dio.post(
      '/api/profile/$nickmame/subscribe',
    );
    return response;
  } catch (e) {
    throw Exception('Failed to subscribe: $e');
    }
  }

  Future<Response> unsubscribeFromProfile(int nickmame) async {
  try {
    final response = await dio.delete(
      '/api/profile/$nickmame/subscribe',
    );
    return response;
  } catch (e) {
    throw Exception('Failed to unsubscribe: $e');
    }
  }

  Future<void> reportComment(int articleId, String message) async {
  try {
    final response = await dio.post(
      '/api/article/$articleId/report',
      data: {
        'message': message,
      },
    );

    if (response.statusCode == 200) {
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
      final response = await dio.patch(
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

  Future<Map<String, dynamic>> fetchUserProfile(int accountId) async {
  try {
    final response = await dio.get('/api/profile/$accountId');
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
Future<Map<String, dynamic>> fetchOwnProfile() async {
  try {
    final response = await dio.get('/api/profile');
    if (response.statusCode == 200) {
      print("Own profile fetched successfully");
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
        'body': body,
        'tags': tags,
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
Future<void> addNote(int articleId, String content) async {
  try {
    final response = await dio.post(
      '/api/article/$articleId/note',
      data: {
        'content': content,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Note added successfully");
    } else {
      throw Exception("Failed to add note");
    }
  } catch (e) {
    print("Error adding note: $e");
    rethrow;
  }
}
Future<Response> deleteNote(int articleId) async {
  final response = await dio.delete('/api/article/$articleId/note');
  return response;
}
}
