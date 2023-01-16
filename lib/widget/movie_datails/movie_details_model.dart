import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Navigation/navigation.dart';
import 'package:flutter_application_1/domain/api_client/api_client_exception.dart';
import 'package:flutter_application_1/domain/entity/local_entity/movie_details_local.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/movie_service.dart';
import 'package:intl/intl.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _authService = AuthService();
  final _movieServise = MovieService();
  bool _isFavorite = false;
  final int movieId;
  MovieDetailsLocal? _movieDatails;
  String _locale = '';
  late DateFormat _dateFormat;

  bool get isFavorite => _isFavorite;
  MovieDetailsLocal? get movieDetails => _movieDatails;

  MovieDetailsModel(this.movieId);

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
    await _loadDetails(context);
  }

  Future<void> _loadDetails(BuildContext context) async {
    try {
      _movieDatails =
          await _movieServise.loadDetails(movieId: movieId, locale: _locale);
    } on ApiClientException catch (e) {
      _errorHandler(e, context);
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final newFavriteValue = !isFavorite;
    _isFavorite = newFavriteValue;
    notifyListeners();
    try {
      _movieServise.updateFavorite(
          movieId: movieId, isFavorite: newFavriteValue);
    } on ApiClientException catch (e) {
      _errorHandler(e, context);
    }
  }

  void _errorHandler(ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        print(exception);
    }
  }
}
