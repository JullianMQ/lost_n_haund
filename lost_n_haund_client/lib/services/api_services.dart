import 'package:dio/dio.dart';
import 'package:lost_n_haund_client/config/api_config.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.androidEmulatorUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<Response> signUp(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        "/users/auth/sign-up",
        data: {
          "user_name": name,
          "user_email": email,
          "user_pass": password,
        },
      );
      return response;
    } catch (e) {
      throw Exception("Sign-up failed: $e");
    }
  }

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "/users/auth/sign-in/email",
        data: {
          "user_email": email,
          "user_pass": password,
        },
      );
      return response;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  Future<Response> createPost(String title, String content) async {
    try {
      final response = await _dio.post(
        "/posts",
        data: {
          "title": title,
          "content": content,
        },
      );
      return response;
    } catch (e) {
      throw Exception("Post creation failed: $e");
    }
  }

  Future<Response> getPosts() async {
    try {
      final response = await _dio.get("/posts");
      return response;
    } catch (e) {
      throw Exception("Fetching posts failed: $e");
    }
  }
}
