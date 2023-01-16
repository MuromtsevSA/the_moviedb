import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/Navigation/navigation.dart';
import 'package:flutter_application_1/domain/entity/movie.dart';
import 'package:flutter_application_1/services/movie_service.dart';
import 'package:flutter_application_1/services/paginator.dart';

class MovieListRowData {
  int id;
  String? posterPath;
  String title;
  String releaseDate;
  String overview;
  MovieListRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.overview,
  });
}

class MovieListViewModel extends ChangeNotifier {
  final _movieService = MovieService();
  late Paginator<Movie> _pularMoviePaginator;
  late Paginator<Movie> _searchMoviePaginator;
  var _movies = <MovieListRowData>[];
  String? _searchQuery;
  Timer? _searchDeboubce;

  MovieListViewModel() {
    _pularMoviePaginator = Paginator<Movie>((page) async {
      final result = await _movieService.getPopularMovie(page, _locale);
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
    _searchMoviePaginator = Paginator<Movie>((page) async {
      final result =
          await _movieService.getSearchMovie(page, _locale, _searchQuery ?? '');
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
  }

  List<MovieListRowData> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  String _locale = '';

  String stringFromDate(DateTime? date) {
    return date != null ? _dateFormat.format(date) : '';
  }

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) {
      return;
    }
    _locale = locale;
    _dateFormat = DateFormat.yMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _pularMoviePaginator.resetList();
    await _searchMoviePaginator.resetList();
    _movies.clear();
    await _loadNextPage();
  }

  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchMoviePaginator.loadNextPage();
      _movies = _pularMoviePaginator.data.map(makeRowData).toList();
    } else {
      await _pularMoviePaginator.loadNextPage();
      _movies = _pularMoviePaginator.data.map(makeRowData).toList();
    }
    notifyListeners();
  }

  MovieListRowData makeRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return MovieListRowData(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        releaseDate: releaseDateTitle,
        overview: movie.overview);
  }

  Future<void> search(String text) async {
    _searchDeboubce?.cancel();
    _searchDeboubce = Timer(const Duration(microseconds: 250), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      _movies.clear();
      if (isSearchMode) {
        await _searchMoviePaginator.resetList();
      }
      _loadNextPage();
    });
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRoutName.movieDatails, arguments: id);
  }

  void showMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}
