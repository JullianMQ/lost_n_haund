import 'package:dio/dio.dart';
import 'package:lost_n_haund_client/config/api_config.dart';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PostService {
  Dio? _dio;
  PersistCookieJar? _cookieJar;

  Future<Dio> _getDio() async {
    if (_dio != null) return _dio!;

    final appDir = await getApplicationDocumentsDirectory();
    final cookieDir = Directory('${appDir.path}/.cookies');

    if (!await cookieDir.exists()) {
      await cookieDir.create(recursive: true);
    }

    _cookieJar = PersistCookieJar(storage: FileStorage(cookieDir.path));
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.hostedUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    _dio!.interceptors.add(CookieManager(_cookieJar!));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    if (token != null) {
      _dio!.options.headers["Authorization"] = "Bearer $token";
    }

    return _dio!;
  }

  Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);

    final dio = await _getDio();
    dio.options.headers["Authorization"] = "Bearer $token";
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");

    if (_dio != null) {
      _dio!.options.headers.remove("Authorization");
    }
  }

  Future<void> _handleInvalidGrant(BuildContext context) async {
    await clearToken();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<Response> _handleRequest(
    BuildContext context,
    Future<Response> Function(Dio dio) request,
  ) async {
    try {
      final dio = await _getDio();
      final response = await request(dio);

      if (response.statusCode == 401 &&
          response.data is Map &&
          response.data['error'] == 'invalid_grant') {
        await _handleInvalidGrant(context);
      }

      return response;
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");

      if (e.response?.statusCode == 401 &&
          e.response?.data is Map &&
          e.response?.data['error'] == 'invalid_grant') {
        await _handleInvalidGrant(context);
      }

      return Response(
        requestOptions: e.requestOptions,
        statusCode: e.response?.statusCode ?? 500,
        statusMessage: e.response?.statusMessage ?? 'Request failed',
        data: e.response?.data ?? {'error': e.message},
      );
    } catch (e, stackTrace) {
      debugPrint("Unexpected error in _handleRequest: $e\n$stackTrace");
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        data: {'error': e.toString()},
      );
    }
  }

  Future<Response> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    return _handleRequest(context, (dio) async {
      final formData = FormData.fromMap({"email": email, "password": password});
      final res = await dio.post("/users/auth/sign-in/email", data: formData);
      if (res.statusCode == 200 && res.data["token"] != null) {
        await setAuthToken(res.data["token"]);
      }
      return res;
    });
  }

  Future<void> logoutUser(BuildContext context) async {
    await _handleRequest(context, (dio) async => dio.post("/users/auth/logout"));
    await _cookieJar?.deleteAll();
    await clearToken();
  }

  Future<Response> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String contact,
    required String studentId,
    required String password,
    required BuildContext context,
  }) async {
    return _handleRequest(context, (dio) async {
      final formData = FormData.fromMap({
        "name": "$firstName $lastName",
        "email": email,
        "phone_num": contact,
        "user_id": studentId,
        "password": password,
      });
      return dio.post("/users/auth/sign-up/email", data: formData);
    });
  }

  Future<Response> createClaim({
    required String firstName,
    required String lastName,
    required String email,
    required String contact,
    required String studentId,
    required String referenceId,
    required String justification,
    required BuildContext context,
    required File imageFile,
    String? ownerId,
  }) async {
    try {
      final dio = await _getDio();

      final uploadResponse = await dio.post(
        '/upload',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(imageFile.path),
        }),
      );

      if (uploadResponse.statusCode != 200) {
        throw Exception("Image upload failed");
      }

      final imageUrl =
          uploadResponse.data['success']?['urlImage']?.toString() ?? '';

      final formData = FormData.fromMap({
        "owner_id": ownerId ?? "guest",
        "first_name": firstName,
        "last_name": lastName,
        "user_email": email,
        "phone_num": contact,
        "user_id": studentId,
        "image_url": imageUrl, 
        "reference_id": referenceId,
        "justification": justification,
      });

      final response = await dio.post("/claims", data: formData);
      return response;
    } catch (e) {
      debugPrint('Error creating claim: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating claim: $e')),
        );
      }
      return Response(
        requestOptions: RequestOptions(path: '/claims'),
        statusCode: 500,
        data: {'error': e.toString()},
      );
    }
  }

  Future<Response> getClaims() async {
    final dio = await _getDio();
    return dio.get("/claims");
  }

  Future<Response> getFilteredClaims({
String? name,
  String? firstName,
  String? lastName,
  String? userId,
  String? ownerId,
}) async {
  final dio = await _getDio();

  String? fName = firstName?.trim();
  String? lName = lastName?.trim();

  if ((fName?.isEmpty ?? true) && (lName?.isEmpty ?? true) && (name?.trim().isNotEmpty ?? false)) {
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      fName = null;
      lName = parts.first;
    } else {
      fName = parts.first;
      lName = parts.sublist(1).join(' ');
    }
  }

  final Map<String, dynamic> qp = {};
  if (fName?.isNotEmpty ?? false) qp['first_name'] = fName;
  if (lName?.isNotEmpty ?? false) qp['last_name'] = lName;
  if (userId?.isNotEmpty ?? false) qp['user_id'] = userId;
  if (ownerId?.isNotEmpty ?? false) qp['owner_id'] = ownerId;

  try {
    final response = await dio.get(
      '/claims',
      queryParameters: qp,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    return response;
  } catch (e) {
    rethrow;
  }
  }

  Future<Response> createLostItem({
    required BuildContext context,
    required String itemName,
    required List<String> itemCategories,
    required String description,
    required String dateFound,
    required String locationFound,
    required File imageFile,
  }) async {
    try {
      final dio = await _getDio();

      final uploadResponse = await dio.post(
        '/upload',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(imageFile.path),
        }),
      );

      if (uploadResponse.statusCode != 200) {
        throw Exception("Image upload failed");
      }

      final imageUrl =
          uploadResponse.data['success']?['urlImage']?.toString() ?? '';

    final res = await dio.post(
    '/posts',
    data: FormData.fromMap({
      'item_name': itemName,
      'item_category': itemCategories, 
      'description': description,
      'date_found': dateFound,
      'location_found': locationFound,
      'image_url': imageUrl,
    }),
  );

      return res;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error: $e')),
        );
      }
      return Response(
        requestOptions: RequestOptions(path: '/posts'),
        statusCode: 500,
        data: {'error': e.toString()},
      );
    }
  }

  Future<Response> getPosts() async {
    final dio = await _getDio();
    return dio.get("/posts");
  }

  Future<Response> getFilteredPosts({
    String? name,
    String? description,
    String? location,
    String? status,
    List<String>? categories,
    int? page,
  }) async {
    final dio = await _getDio();
    final Map<String, dynamic> qp = {};

    if (name?.isNotEmpty ?? false) qp['name'] = name;
    if (description?.isNotEmpty ?? false) qp['description'] = description;
    if (location?.isNotEmpty ?? false) qp['location'] = location;
    if (status?.isNotEmpty ?? false) qp['status'] = status;
    if (categories?.isNotEmpty ?? false) qp['categories'] = categories;
    if (page != null) qp['page'] = page.toString();

    return dio.get("/posts", queryParameters: qp);
  }

    Future<Map<String, dynamic>> acceptClaim(String claimId) async {
    try {
      final dio = await _getDio(); 
      final response = await dio.post('/claims/accept/$claimId');
      return {'message': response.data['message'] ?? 'Claim accepted'};
    } catch (e) {
      debugPrint("Error in acceptClaim: $e");
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteClaim(String claimId) async {
  try {
    final dio = await _getDio(); 
    final response = await dio.delete('/claims/$claimId'); 
    return {'message': response.data['message'] ?? 'Claim deleted successfully'};
  } catch (e) {
    debugPrint("Error deleting the claim: $e");
    return {'error': e.toString()};
  }
}


  Future<Response> updateClaim(String claimId, Map<String, dynamic> updatedData) async {
    try {
      final dio = await _getDio();

      final formData = FormData.fromMap(updatedData);

      final response = await dio.put(
        '/claims/$claimId',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      if (response.statusCode == 200) {
        debugPrint(" Successfully updated claim: $claimId");
      } else {
        debugPrint(" Failed to update claim: ${response.statusCode}");
      }

      return response;
    } catch (e) {
      debugPrint("Error updating claim: $e");
      return Response(
        requestOptions: RequestOptions(path: '/claims/$claimId'),
        statusCode: 500,
        data: {'error': e.toString()},
      );
    }
  }


  Future<Map<String, dynamic>> denyClaim(String claimId) async {
    try {
      final dio = await _getDio(); 
      final response = await dio.post('/claims/deny/$claimId');
      return {'message': response.data['message'] ?? 'Claim denied'};
    } catch (e) {
      debugPrint("Error in acceptClaim: $e");
      return {'error': e.toString()};
    }
  }

  Future<List<dynamic>> getUsers({
    String? name,
    String? userId,
    String? email,
    String? password,
    int page = 0,
  }) async {
    try {
      final dio = await _getDio();
      final query = {
        if (name != null && name.isNotEmpty) 'name': name,
        if (userId != null && userId.isNotEmpty) 'user_id': userId, 
        if (email != null && email.isNotEmpty) 'email': email,
        if (password != null && password.isNotEmpty) 'password': password,
        'page': page,
      };

      final response = await dio.get(
        '/users/auth/admin/list-users',
        queryParameters: query,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = List<Map<String, dynamic>>.from(response.data['users'] ?? []);

        for (var user in data) {
          if (user['_id'] == null && user['id'] != null) {
            user['_id'] = user['id']; 
          }
        }

        print("Raw users data: $data");
        return data;
      } else {
        throw Exception('Failed to load users');
      }
    } on DioException catch (e) {
      print("Error fetching users: ${e.response?.data ?? e.message}");
      rethrow;
    }
  }

  Future<void> removeUser({
  required String id,  
  required String token,
  required String email,
}) async {
  try {
    final dio = await _getDio();

    print('Removing user → MongoDB _id: $id');  
    print(' | email: $email');  

    final response = await dio.post(
      '/users/auth/admin/remove-user',
      data: {
        "userId": id,  
        "email": email,  
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
    );

    if (response.statusCode == 200) {
      print("User removed successfully: ${response.data}");
    } else {
      throw Exception('Failed to remove user: ${response.statusCode}');
    }
  } on DioException catch (e) {
    print("Failed to remove user: ${e.response?.data ?? e.message}");
    if (e.response != null) {
      print("Full error response: ${e.response?.data}");
    }
    rethrow;
  } catch (e) {
    print(" Unexpected error removing user: $e");
    rethrow;
  }
}

  Future<Response> updateUser({
    required String name,
    required String image,
    required String token,

  }) async {
    final dio = await _getDio();

    try {
      final res = await dio.post(
        '/users/auth/update-user',
        data: {
          "name": name,
          "image": image,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

Future<void> banUser({
  required String id,      
  required String token,   
  required String reason,  
}) async {
  try {
    final dio = await _getDio();

    print('Banning user → MongoDB _id: $id');
    print(' | Reason: $reason');

    final response = await dio.post(
      '/users/auth/admin/ban-user',
      data: {
        "userId": id,
        "banReason": reason,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
    );

    if (response.statusCode == 200) {
      print("✅ User banned successfully: ${response.data}");
    } else {
      throw Exception(' Failed to ban user: ${response.statusCode}');
    }
  } on DioException catch (e) {
    print(" Failed to ban user: ${e.response?.data ?? e.message}");
    if (e.response != null) {
      print("Full error response: ${e.response?.data}");
    }
    rethrow;
  } catch (e) {
    print(" Unexpected error banning user: $e");
    rethrow;
  }
}

Future<void> unbanUser({
  required String id,
  required String token,
}) async {
  try {
    final dio = await _getDio();

    print('Unbanning user → MongoDB _id: $id');

    final response = await dio.post(
      '/users/auth/admin/unban-user',
      data: {
        "userId": id,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
    );

    if (response.statusCode == 200) {
      print(" User unbanned successfully: ${response.data}");
    } else {
      throw Exception(' Failed to unban user: ${response.statusCode}');
    }
  } on DioException catch (e) {
    print(" Failed to unban user: ${e.response?.data ?? e.message}");
    if (e.response != null) {
      print("Full error response: ${e.response?.data}");
    }
    rethrow;
  } catch (e) {
    print(" Unexpected error unbanning user: $e");
    rethrow;
  }

  
}




}
  

