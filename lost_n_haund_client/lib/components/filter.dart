import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/services/post_service.dart';

class FilterProvider with ChangeNotifier {
  final PostService _postService = PostService();

  String _selectedCategory = '';
  String _selectedLocation = '';
  String _searchQuery = '';

  List _posts = [];
  bool _isLoading = false;

  String get selectedCategory => _selectedCategory.isEmpty ? "Category" : _selectedCategory;
  String get selectedLocation => _selectedLocation.isEmpty ? "Location" : _selectedLocation;
  String get searchQuery => _searchQuery.isEmpty ? "Search" : _searchQuery;
  List get posts => _posts;
  bool get isLoading => _isLoading;

  FilterProvider() {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _postService.getFilteredPosts(
        categories: _selectedCategory.isNotEmpty ? [_selectedCategory] : null,
        location: _selectedLocation.isNotEmpty ? _selectedLocation : null,
        name: _searchQuery.isNotEmpty ? _searchQuery : null, 
      );

      if (res.statusCode == 200) {
        _posts = res.data;
      } else {
        _posts = [];
      }
    } catch (e) {
      _posts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    fetchPosts();
  }

  void setLocation(String location) {
    _selectedLocation = location;
    fetchPosts();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchPosts();
  }

  void sortByDate() {
    _posts.sort((a, b) {
      DateTime dateA = DateTime.tryParse(a['date_found'] ?? '') ?? DateTime(1970);
      DateTime dateB = DateTime.tryParse(b['date_found'] ?? '') ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = '';
    _selectedLocation = '';
    _searchQuery = '';
    fetchPosts();
  }
}
