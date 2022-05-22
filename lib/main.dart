import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repository/movie_reporitory_impl.dart';
import 'movie_list_bloc.dart';
import 'movie_list_state.dart';
import 'movie_list_event.dart';
import 'movie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) =>
            MovieListBloc(MovieRepositoryImpl())..add(MovieListFetch()),
        child: MovieList(),
      ),
    );
  }
}

class MovieList extends StatefulWidget {
  MovieList({Key? key}) : super(key: key);

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieListBloc, MovieListState>(
          builder: (context, state) {
        if (state.movies.isEmpty && state.status == MovieListStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          controller: _scrollController,
          itemCount: state.hasReachedMax
              ? state.movies.length
              : state.movies.length + 1,
          itemBuilder: (_, index) {
            if (index >= state.movies.length) return BottomLoader();
            return MovieListItem(movie: state.movies[index]);
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<MovieListBloc>().add(MovieListFetch());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class MovieListItem extends StatelessWidget {
  const MovieListItem({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(movie.title ?? '-'),
        subtitle: Text(movie.releaseDate ?? '-'),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(movie.poster),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
