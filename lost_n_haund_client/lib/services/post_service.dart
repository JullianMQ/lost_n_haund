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
      String? uploadedUrl;

      if (imageFile != null) {
        final uploadForm = FormData.fromMap({
          "file": await MultipartFile.fromFile(imageFile.path,
              filename: imageFile.path.split("/").last),
        });

        final uploadRes = await _dio.post("/upload", data: uploadForm);

        if (uploadRes.statusCode == 200 && uploadRes.data["success"] != null) {
          uploadedUrl = uploadRes.data["success"]["urlImage"];
        }
      }

      final formData = FormData.fromMap({
        "first_name": firstName,
        "last_name": lastName,
        "user_email": email,
        "phone_num": contact,
        "user_id": studentId,
        "reference_id": referenceId,
        "justification": justification,
        if (uploadedUrl != null) "image_url": uploadedUrl,
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
    required List<String> itemCategory,
    required String description,
    required String dateFound,
    required String locationFound,
    File? imageFile,
  }) async {
    try {
      String? uploadedUrl;

      if (imageFile != null) {
        final uploadForm = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split("/").last,
          ),
        });

        final uploadRes = await _dio.post("/upload", data: uploadForm);

        if (uploadRes.statusCode == 200 && uploadRes.data["success"] != null) {
          uploadedUrl = uploadRes.data["success"]["urlImage"];
        }
      }

      final formData = FormData();

      formData.fields
        ..add(MapEntry("item_name", itemName))
        ..add(MapEntry("description", description))
        ..add(MapEntry("date_found", dateFound))
        ..add(MapEntry("location_found", locationFound))
        ..add(MapEntry("status", "pending"));

      for (final category in itemCategory) {
        formData.fields.add(MapEntry("item_category", category));
      }

      if (uploadedUrl != null) {
        formData.fields.add(MapEntry("image_url", uploadedUrl));
      }

      final res = await _dio.post(
        "/posts",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      return res;
      } on DioException catch (e) {
        return e.response ??
            Response(
              requestOptions: e.requestOptions,
              statusCode: 500,
              statusMessage: "Internal client error",
            );
          }
    }
  }