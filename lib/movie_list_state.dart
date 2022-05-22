import 'package:equatable/equatable.dart';

import 'movie.dart';

enum MovieListStatus { initial, loading, success, failure }

class MovieListState extends Equatable {
  final int page;
  final MovieListStatus status;
  final List<Movie> movies;
  final bool hasReachedMax;

  const MovieListState({
    this.page = 1,
    this.status = MovieListStatus.initial,
    this.movies = const <Movie>[],
    this.hasReachedMax = false,
  });

  MovieListState success(List<Movie> movies) {
    return MovieListState(
      page: page + 1,
      status: MovieListStatus.success,
      movies: List.of(this.movies)..addAll(movies),
      hasReachedMax: movies.isEmpty,
    );
  }

  MovieListState loading() {
    return MovieListState(
        page: page,
        status: MovieListStatus.loading,
        movies: movies,
        hasReachedMax: hasReachedMax);
  }

  @override
  List<Object?> get props => [page, status, movies, hasReachedMax];
}
