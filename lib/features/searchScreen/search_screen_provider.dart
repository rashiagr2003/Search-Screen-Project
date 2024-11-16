import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier {
  bool _isLoading = false;
  List<dynamic> _searchResults = [];

  bool get isLoading => _isLoading;
  List<dynamic> get searchResults => _searchResults;

  // Method to fetch search results
  Future<void> fetchSearchResults(String query) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      query.isEmpty
          ? 'https://api.tvmaze.com/search/shows?q=all'
          : 'https://api.tvmaze.com/search/shows?q=$query',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _searchResults = data; // API already provides a list of shows
      } else {
        debugPrint('Unexpected response: ${response.statusCode}');
        _searchResults = [];
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to clear search results
  void clearResults() {
    _searchResults = [];
    notifyListeners();
  }
}
