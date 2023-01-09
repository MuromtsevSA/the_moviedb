import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/domain/api_client/api_client.dart';
import 'package:flutter_application_1/domain/data_provider/my_app_model.dart';
import 'package:flutter_application_1/domain/data_provider/session_data_providers.dart';
import 'package:flutter_application_1/domain/entity/movie_details.dart';
import 'package:intl/intl.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final int movieId;
  MovieDetails? _movieDatails;
  bool _isFavorite = false;
  String _locale = '';
  late DateFormat _dateFormat;

  bool get isFavorite => _isFavorite;
  MovieDetails? get movieDetails => _movieDatails;

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
    await _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      _movieDatails = await _apiClient.getMovieDetails(movieId, _locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavorite = await _apiClient.isFavorite(movieId, sessionId);
      }
      notifyListeners();
    } on ApiClientException catch (e) {
      _errorHandler(e);
    }
  }

  Future<void> toggleFavorite() async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();
    if (accountId == null || sessionId == null) {
      return;
    }

    final newFavriteValue = !_isFavorite;
    _isFavorite = newFavriteValue;
    notifyListeners();
    try {
      await _apiClient.markAsFavorite(
          accountId: accountId,
          sessionId: sessionId,
          mediaType: MediaType.Movie,
          mediaId: movieId,
          isFavorite: newFavriteValue);
    } on ApiClientException catch (e) {
      _errorHandler(e);
    }
  }

  void _errorHandler(ApiClientException excepetion) {
    switch (excepetion.type) {
      case ApiClientExceptionType.SessionExpired:
        break;
      default:
        print(excepetion);
    }
  }
}
