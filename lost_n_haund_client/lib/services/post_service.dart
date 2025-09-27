import 'package:dio/dio.dart';
import 'package:lost_n_haund_client/config/api_config.dart';
import 'dart:io';

class PostService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.androidEmulatorUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Response> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final formData = FormData.fromMap({
        "email": email,
        "password": password,
      });

      final res = await _dio.post("/users/auth/sign-in/email", data: formData);

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
        "name": "$firstName $lastName",
        "email": email,
        "phone_num": contact,
        "user_id": studentId,
        "password": password,
      });

      final response = await _dio.post(
        "/users/auth/sign-up/email",
        data: formData,
      );

      return response;
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 500,
            statusMessage: "Sign-up failed: ${e.message}",
          );
    }
  }

  Future<Response> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final formData = FormData.fromMap({
        "email": email,
        "password": password,
      });

      final res = await _dio.post("/users/auth/sign-in/email", data: formData);
      return res;
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 500,
            statusMessage: "Login failed: ${e.message}",
          );
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

      final formData = FormData.fromMap({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_num": contact,
        "user_id": studentId,
        "reference_id": referenceId,
        "justification": justification,
        if (uploadedUrl != null) "image_url": uploadedUrl,
      });

      final res = await _dio.post("/claims", data: formData);
      return res;
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 500,
            statusMessage: "Claim creation failed: ${e.message}",
          );
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

        if (uploadRes.statusCode == 200) {
          uploadedUrl = uploadRes.data["success"]["urlImage"];
        }
      }

      final formData = FormData.fromMap({
        "item_name": itemName,
        "item_category": itemCategory, 
        "description": description,
        "date_found": dateFound,
        "location_found": locationFound,
        "status": "pending",
        if (uploadedUrl != null) "image_url": uploadedUrl,
      });

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
            statusMessage: "Lost item creation failed: ${e.message}",
          );
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
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      return response;
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 500,
            statusMessage: "Post creation failed: ${e.message}",
          );
    }
  }

  Future<Response> getPosts() async {
    try {
      final response = await _dio.get("/posts");
      return response;
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 500,
            statusMessage: "Fetching posts failed: ${e.message}",
          );
    }
  }

  Future<Response> getFilteredPosts({
    String? name,
    String? description,
    String? location,
    String? status,
    List<String>? categories,
    int? page,
    String? search,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (name != null && name.isNotEmpty) {
      queryParams['name'] = name;
    }

    if (location != null && location.isNotEmpty) {
      queryParams['location'] = location;
    }

    if (categories != null && categories.isNotEmpty) {
      queryParams['categories'] = categories; 
    }

    if (page != null) {
      queryParams['page'] = page.toString();
    }

    if (search != null && search.isNotEmpty) { 
    queryParams['search'] = search;
  }

    return await _dio.get(
      "/posts",
      queryParameters: queryParams,
    );
  }
}
