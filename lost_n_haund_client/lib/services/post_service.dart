import 'package:dio/dio.dart';
import 'package:lost_n_haund_client/config/api_config.dart';

class PostService {
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

  Future<Response> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String contact,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "/register", // ✅ update to your backend’s register endpoint
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "contact": contact,
          "password": password,
        },
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      throw Exception("Failed to connect to server: ${e.message}");
    }
  }
}
