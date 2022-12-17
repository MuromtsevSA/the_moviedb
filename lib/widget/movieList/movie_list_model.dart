import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Navigation/navigation.dart';
import 'package:intl/intl.dart';

import '../../domain/api_client/api_client.dart';
import '../../domain/entity/movie.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final List<Movie> _movies = [];
  late int _currentPage;
  late int _totalPage;
  var _isLoadingInProgress = false;
  List<Movie> get movies => List.unmodifiable(_movies);
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
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
    await loadMovies();
  }

  Future<void> loadMovies() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;
    try {
      final moviesResponse =
          await _apiClient.getPopularMovie(nextPage, _locale);
      _movies.addAll(moviesResponse.movies);
      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;
      _isLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRoutName.movieDatails, arguments: id);
  }

  void showMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    loadMovies();
  }
}
