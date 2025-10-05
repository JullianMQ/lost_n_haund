import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/services/post_service.dart';

class ClaimFilterProvider with ChangeNotifier {
  final PostService _postService = PostService();

  String _name = '';
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
      String? firstName;
      String? lastName;

      if (_name.isNotEmpty) {
        final parts = _name.trim().split(RegExp(r'\s+'));
        firstName = parts.isNotEmpty ? parts.first : null;
        lastName = parts.length > 1 ? parts.sublist(1).join(' ') : null;
      }

      final res = await _postService.getFilteredClaims(
        firstName: firstName?.isNotEmpty == true ? firstName : null,
        lastName: lastName?.isNotEmpty == true ? lastName : null,
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
      debugPrint('Error fetching claims: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
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
    _name = '';
    _userId = '';
    _ownerId = '';
    fetchClaims();
  }
}
