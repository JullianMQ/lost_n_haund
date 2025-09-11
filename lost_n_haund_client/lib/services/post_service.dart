import 'package:dio/dio.dart';
import 'package:lost_n_haund_client/config/api_config.dart';
import 'dart:io';

class PostService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.androidEmulatorUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  Future<Response> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final formData = FormData.fromMap({
        "user_email": email,
        "user_pass": password,
      });

      final res = await _dio.post("/users/auth/sign-in/email", data: formData);

      // print(res.data); // use this output in the future for sessions
      return res;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      throw Exception("Failed to connect to server: ${e.message}");
    }
  }

  Future<Response> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String contact,
    required String studentId,
    required String password,
  }) async {
    try {
      final formData = FormData.fromMap({
        "user_name": "$firstName $lastName",
        "user_email": email,
        "phone_num": contact,
        "user_id": studentId,
        "user_pass": password,
      });

      final response = await _dio.post(
        "/users/auth/sign-up/email",
        data: formData,
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      throw Exception("Failed to connect to server: ${e.message}");
    }
  }

  Future<Response> createClaim({
    required String firstName,
    required String lastName,
    required String email,
    required String contact,
    required String studentId,
    required String referenceId,
    required String justification,
    File? imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        "first_name": firstName,
        "last_name": lastName,
        "user_email": email,
        "phone_num": contact,
        "user_id": studentId,
        "reference_id": referenceId,
        "justification": justification,
        if (imageFile != null)
          "file": await MultipartFile.fromFile(imageFile.path,
              filename: imageFile.path.split("/").last),
      });

      final res = await _dio.post("/claims", data: formData);
      return res;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception("Failed to connect to server: ${e.message}");
    }
  }

  Future<Response> createLostItem({
    required String itemName,
    required String itemCategory,
    required String description,
    required String dateFound,
    required String locationFound,
    File? imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        "item_name": itemName,
        "item_category": itemCategory,
        "description": description,
        "date_found": dateFound,
        "location_found": locationFound,
        "status": "pending",
        // if (imageFile != null)
        //   "file": await MultipartFile.fromFile(imageFile.path,
        //       filename: imageFile.path.split("/").last),
      });

      final res = await _dio.post("/posts", data: formData);
      return res;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception("Failed to connect to server: ${e.message}");
    }
  }
}
