import 'package:dio/dio.dart';
import 'package:lost_n_haund_client/config/api_config.dart';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class PostService {
  late Dio _dio;
  PersistCookieJar? _cookieJar;

  PostService() {
    _initCookieJar();
  }

  Future<void> _initCookieJar() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = Directory('${appDocDir.path}/.cookies');

    if (!await cookiePath.exists()) {
      await cookiePath.create(recursive: true);
    }

    _cookieJar = PersistCookieJar(storage: FileStorage(cookiePath.path));

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.androidEmulatorUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio!.interceptors.add(CookieManager(_cookieJar!));
  }

  Future<Dio> _getDio() async {
    if (_dio == null) {
      await _initCookieJar();
    }
    return _dio!;
  }

  Future<Response> loginUser({
    required String email,
    required String password,
  }) async {
    final dio = await _getDio();
    try {
      final formData = FormData.fromMap({
        "email": email,
        "password": password,
      });

      final res = await dio.post(
        "/users/auth/sign-in/email",
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );
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

  Future<void> logoutUser() async {
    final dio = await _getDio();
    try {
      await dio.post("/users/auth/logout");
    } catch (_) {}
    if (_cookieJar != null) {
      await _cookieJar!.deleteAll();
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
    final dio = await _getDio();
    try {
      final formData = FormData.fromMap({
        "name": "$firstName $lastName",
        "email": email,
        "phone_num": contact,
        "user_id": studentId,
        "password": password,
      });

      final response = await dio.post("/users/auth/sign-up/email", data: formData);
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
    final dio = await _getDio();
    try {
      String? uploadedUrl;

      if (imageFile != null) {
        final uploadForm = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split("/").last,
          ),
        });
        final uploadRes = await dio.post("/upload", data: uploadForm);
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

      final res = await dio.post("/claims", data: formData);
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

  Future<Response> getClaims() async {
    final dio = await _getDio();
    try {
      final response = await dio.get("/claims");
      return response;
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 500,
            statusMessage: "Fetching claims failed: ${e.message}",
          );
    }
  }

  Future<Response> getFilteredClaims({
    String? name,
    String? description,
    String? location,
    String? status,
    List<String>? categories,
    int? page,
    String? search,
  }) async {
    final dio = await _getDio();
    final Map<String, dynamic> queryParams = {};

    if (name != null && name.isNotEmpty) queryParams['name'] = name;
    if (description != null && description.isNotEmpty) queryParams['description'] = description;
    if (location != null && location.isNotEmpty) queryParams['location'] = location;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (categories != null && categories.isNotEmpty) queryParams['categories'] = categories;
    if (page != null) queryParams['page'] = page.toString();
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    return await dio.get("/claims", queryParameters: queryParams);
  }

  Future<Response> createLostItem({
    required String itemName,
    required List<String> itemCategory,
    required String description,
    required String dateFound,
    required String locationFound,
    File? imageFile,
  }) async {
    final dio = await _getDio();
    try {
      String? uploadedUrl;

      if (imageFile != null) {
        final uploadForm = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split("/").last,
          ),
        });
        final uploadRes = await dio.post("/upload", data: uploadForm);
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

      final res = await dio.post("/posts", data: formData);
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

  Future<Response> getPosts() async {
    final dio = await _getDio();
    try {
      final response = await dio.get("/posts");
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
    final dio = await _getDio();
    final Map<String, dynamic> queryParams = {};

    if (name != null && name.isNotEmpty) queryParams['name'] = name;
    if (location != null && location.isNotEmpty) queryParams['location'] = location;
    if (categories != null && categories.isNotEmpty) queryParams['categories'] = categories;
    if (page != null) queryParams['page'] = page.toString();
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    return await dio.get("/posts", queryParameters: queryParams);
  }
}
