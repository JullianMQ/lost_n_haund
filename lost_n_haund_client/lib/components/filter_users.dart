import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/services/post_service.dart';

class UserFilterProvider with ChangeNotifier {
  final _service = PostService();
  bool isLoading = false;
  List<Map<String, dynamic>> users = [];

  String name = '';
  String userId = '';
  String email = '';
  String password = '';

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setUserId(String value) {
    userId = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _service.getUsers(
        name: name,
        email: email,
        password: password,
      );
      users = List<Map<String, dynamic>>.from(result);
    } catch (e) {
      print('Error fetching users: $e');
      users = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
