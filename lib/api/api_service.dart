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

Future<void> likeComment(int articleId) async {
  final response = await dio.post('/api/article/$articleId/like');
  if (response.statusCode != 200) {
    throw Exception('Failed to like comment');
  }
}

Future<void> unlikeComment(int articleId) async {
  final response = await dio.delete('/api/article/$articleId/like');
  if (response.statusCode != 200) {
    throw Exception('Failed to unlike comment');
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
Future<Response> subscribeToArticle(int articleId) async {
  try {
    final response = await dio.post(
      '/api/profile/$articleId/subscribe',
    );
    return response;
  } catch (e) {
    throw Exception('Failed to subscribe: $e');
    }
  }
}
