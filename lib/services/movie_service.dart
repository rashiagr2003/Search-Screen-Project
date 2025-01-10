import 'package:dio/dio.dart';
import '../features/searchScreen/models/search_model.dart';

class MovieService {
  final Dio _dio = Dio();

  // Fetch data using TVMaze API
  Future<List<SearchScreenModel>> searchMoviesTVMaze(String query) async {
    final url = "https://api.tvmaze.com/search/shows?q=$query";
    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      List data = response.data;
      return data.map((json) => SearchScreenModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // Fetch data using TMDb API
  Future<List<SearchScreenModel>> searchMoviesTMDb(
      String query, String apiKey) async {
    final url =
        "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query";
    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      List results = response.data['results'];
      return results.map((json) => SearchScreenModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
