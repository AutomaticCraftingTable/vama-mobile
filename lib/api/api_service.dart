import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  late final Dio dio;

  ApiService._internal() {
    dio = Dio(BaseOptions(
      baseUrl: "http://10.0.2.2:3658/m1/904302-886494-default",
      headers: {"Content-Type": "application/json"},
    ));

    if (kDebugMode) {
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          print("REQUEST ${options.method} ${options.uri}");
          print("> DATA: ${options.data}");
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
}
