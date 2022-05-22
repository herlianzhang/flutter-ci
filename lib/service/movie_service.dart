import 'dart:convert';

import 'package:http/http.dart' as http;
import '../movie.dart';

class MovieService {
  const MovieService();

  Future<List<Movie>> getMovies(int page) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYjIwOWM1ZjJhZjMwZjc0MjZmNGU4NzRmNGQ1NjIxMiIsInN1YiI6IjVkYzRmNDY1YWIxYmM3MDAxM2ZlNDA4OSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.EnpkajfHJW0khwqwGEGfLrkm8PCL9O2gyx7MuXZdHyU',
    };
    http.Response response = await http
        .get(
          Uri.parse('https://api.themoviedb.org/3/movie/upcoming?page=$page'), 
          headers: headers
          );
    
    return (jsonDecode(response.body)['results'] as List<dynamic>).map((e) => Movie.fromJson(e)).toList();
  }
}
