import '../service/movie_service.dart';

import '../movie.dart';
import './movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  final MovieService service;

  MovieRepositoryImpl({this.service = const MovieService()});

  @override
  Future<List<Movie>> getMovies({required int page}) {
    return service.getMovies(page);
  }
}
