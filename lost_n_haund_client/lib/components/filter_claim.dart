import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/services/post_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ClaimFilterProvider with ChangeNotifier {
  final PostService _postService = PostService();

  String _firstName = '';
  String _lastName = '';
  String _userId = '';
  String _ownerId = '';

  List _claims = [];
  bool _isLoading = false;

  List get claims => _claims;
  bool get isLoading => _isLoading;

  Future<void> fetchClaims() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      print(' Token used in fetchClaims: $token');

    final res = await _postService.getFilteredClaims(
      firstName: _firstName.isNotEmpty ? _firstName : null,
      lastName: _lastName.isNotEmpty ? _lastName : null,
      userId: _userId.isNotEmpty ? _userId : null,
      ownerId: _ownerId.isNotEmpty ? _ownerId : null,
    );


      if (res.statusCode == 200 && res.data != null) {
        _claims = res.data is List ? res.data : [];
      } else {
        _claims = [];
      }
    } catch (e) {
      _claims = [];
      debugPrint(' Error fetching claims: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void setFirstName(String value) {
    _firstName = value;
    fetchClaims();
  }

  void setLastName(String value) {
    _lastName = value;
    fetchClaims();
  }

  void setUserId(String value) {
    _userId = value;
    fetchClaims();
  }

  void setOwnerId(String value) {
    _ownerId = value;
    fetchClaims();
  }

  void sortByDate() {
    _claims.sort((a, b) {
      final dateA =
          DateTime.tryParse(a['date_found'] ?? '') ?? DateTime(1970);
      final dateB =
          DateTime.tryParse(b['date_found'] ?? '') ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });
    notifyListeners();
  }

  void clearFilters() {
    _firstName = '';
    _lastName = '';
    _userId = '';
    _ownerId = '';
    fetchClaims();
  }
}
