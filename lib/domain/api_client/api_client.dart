import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/configuration/configuration.dart';
import 'package:flutter_application_1/domain/api_client/api_client_exception.dart';
import 'package:flutter_application_1/domain/api_client/api_client_validate_response.dart';
import 'package:flutter_application_1/domain/entity/movie_details.dart';
import 'package:flutter_application_1/domain/entity/popular_movie_response.dart';

class ApiClient {
  final Dio _client = Dio(BaseOptions(
    baseUrl: Configuration.host,
    headers: {
      'Content-Type': 'application/json',
      'X-RapidAPI-Host': 'https://api.themoviedb.org/3',
      'X-RapidAPI-Key': '....',
      'useQueryString': true
    },
  ));

  static String imgUrl(String path) {
    return Configuration.imageUrl + path;
  }

  Future<PopularMovieResponse> getPopularMovie(
      int page, String locale, String apiKey) async {
    try {
      Response response = await _client.get("/movie/popular?",
          queryParameters: <String, dynamic>{
            "api_key": apiKey,
            "language": locale,
            "page": page.toString()
          });
      ValidateResponse.validateResponse(response);
      final movies =
          PopularMovieResponse.fromJson(response.data as Map<String, dynamic>);
      return movies;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<PopularMovieResponse> getSearchMovie(
      int page, String locale, String query, String apiKey) async {
    try {
      Response response =
          await _client.get("/search/movie", queryParameters: <String, dynamic>{
        "api_key": apiKey,
        "language": locale,
        "page": page.toString(),
        "query": query,
        "include_adult": true.toString(),
      });
      ValidateResponse.validateResponse(response);
      final movies =
          PopularMovieResponse.fromJson(response.data as Map<String, dynamic>);
      return movies;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<MovieDetails> getMovieDetails(int movieId, String locale) async {
    try {
      Response response = await _client
          .get("/movie/$movieId", queryParameters: <String, dynamic>{
        "append_to_response": "credits,videos",
        "api_key": Configuration.apiKey,
        "language": locale,
      });
      ValidateResponse.validateResponse(response);
      final movies =
          MovieDetails.fromJson(response.data as Map<String, dynamic>);
      return movies;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<bool> isFavorite(int movieId, String sessionId) async {
    try {
      Response response = await _client.get("/movie/$movieId/account_states",
          queryParameters: <String, dynamic>{
            "api_key": Configuration.apiKey,
            "session_id": sessionId,
          });
      ValidateResponse.validateResponse(response);
      final movies = response.data['favorite'] as bool;
      return movies;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }
}
