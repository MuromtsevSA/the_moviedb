import 'package:flutter_application_1/configuration/configuration.dart';
import 'package:flutter_application_1/domain/api_client/account_api_client.dart';
import 'package:flutter_application_1/domain/api_client/api_client.dart';
import 'package:flutter_application_1/domain/data_provider/session_data_providers.dart';
import 'package:flutter_application_1/domain/entity/local_entity/movie_details_local.dart';
import 'package:flutter_application_1/domain/entity/popular_movie_response.dart';

class MovieService {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();

  Future<PopularMovieResponse> getPopularMovie(int page, String locale) async =>
      await _apiClient.getPopularMovie(
        page,
        locale,
        Configuration.apiKey,
      );

  Future<PopularMovieResponse> getSearchMovie(
          int page, String locale, String query) async =>
      await _apiClient.getSearchMovie(
        page,
        locale,
        query,
        Configuration.apiKey,
      );

  Future<MovieDetailsLocal> loadDetails({
    required int movieId,
    required String locale,
  }) async {
    final movieDatails = await _apiClient.getMovieDetails(movieId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    var isFavorite = false;
    if (sessionId != null) {
      isFavorite = await _apiClient.isFavorite(movieId, sessionId);
    }

    return MovieDetailsLocal(details: movieDatails, isFavorite: isFavorite);
  }

  Future<void> updateFavorite(
      {required int movieId, required bool isFavorite}) async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();
    if (accountId == null || sessionId == null) {
      return;
    }
    await _accountApiClient.markAsFavorite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.movie,
        mediaId: movieId,
        isFavorite: isFavorite);
  }
}
