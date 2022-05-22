import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_list_event.dart';
import 'movie_list_state.dart';
import 'repository/movie_repository.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieRepository _movieRepository;
  int page = 1;

  MovieListBloc(this._movieRepository) : super(const MovieListState()) {
    _listenFetchEvent();
  }

  void _listenFetchEvent() {
    on<MovieListFetch>((event, emit) async {
      if (state.status == MovieListStatus.loading) return;
      emit(state.loading());
      _fetchMovies();
    });
  }

  void _fetchMovies() async {
    try {
      final movies = await _movieRepository.getMovies(page: state.page);
      emit(state.success(movies));
    } on Exception catch (e) {
      print(e);
    }
  }
}
