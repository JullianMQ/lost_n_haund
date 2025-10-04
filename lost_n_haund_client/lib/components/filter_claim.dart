import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/services/post_service.dart';

class ClaimFilterProvider with ChangeNotifier {
  final PostService _postService = PostService();

  String _selectedCategory = '';
  String _selectedLocation = '';
  String _searchQuery = '';

  List _claims = [];
  bool _isLoading = false;

  String get selectedCategory =>
      _selectedCategory.isEmpty ? "Category" : _selectedCategory;
  String get selectedLocation =>
      _selectedLocation.isEmpty ? "Location" : _selectedLocation;
  String get searchQuery => _searchQuery.isEmpty ? "Search" : _searchQuery;

  List get claims => _claims;
  bool get isLoading => _isLoading;

  Future<void> fetchClaims() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _postService.getFilteredClaims(
        categories: _selectedCategory.isNotEmpty ? [_selectedCategory] : null,
        location: _selectedLocation.isNotEmpty ? _selectedLocation : null,
        name: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      if (res.statusCode == 200) {
        _claims = res.data;
      } else {
        _claims = [];
      }
    } catch (e) {
      _claims = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    fetchClaims();
  }

  void setLocation(String location) {
    _selectedLocation = location;
    fetchClaims();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchClaims();
  }

  void sortByDate() {
    _claims.sort((a, b) {
      DateTime dateA =
          DateTime.tryParse(a['date_found'] ?? '') ?? DateTime(1970);
      DateTime dateB =
          DateTime.tryParse(b['date_found'] ?? '') ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = '';
    _selectedLocation = '';
    _searchQuery = '';
    fetchClaims();
  }
}
