import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/domain/entity/movie_details.dart';
import 'package:flutter_application_1/domain/entity/popular_movie_response.dart';

enum ApiClientExceptionType { Network, Auth, Other, SessionExpired }

enum MediaType { Movie, TV }

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.Movie:
        return "movie";
      case MediaType.TV:
        return "tv";
    }
  }
}

class ApiClientException implements Exception {
  final ApiClientExceptionType type;
  ApiClientException(this.type);
}

class ApiClient {
  final Dio _client = Dio();
  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = 'ed22f6a0b5fe2885031bb0c9237efa36';

  static String imgUrl(String path) {
    return _imageUrl + path;
  }

  Future<String> auth(
      {required String username, required String password}) async {
    final token = await _makeToken();
    final validateToken = await _validateUser(
        username: username, password: password, request_token: token);
    final sessionId = await _makeSession(request_token: validateToken);
    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parametrs]) {
    final uri = Uri.parse('$_host$path');
    if (parametrs != null) {
      return uri.replace(queryParameters: parametrs);
    } else {
      return uri;
    }
  }

  Future<String> _makeToken() async {
    final url = _makeUri(
        "/authentication/token/new", <String, dynamic>{"api_key": _apiKey});
    try {
      Response response = await _client.getUri(url);
      _validateResponse(response);
      final token = response.data["request_token"];
      return token;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<String> _validateUser(
      {required String username,
      required String password,
      required String request_token}) async {
    final formData = FormData.fromMap({
      "username": username,
      "password": password,
      "request_token": request_token,
    });
    try {
      Response response = await _client.post(
          "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=$_apiKey",
          data: formData,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      _validateResponse(response);
      final token = response.data["request_token"];
      return token;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<String> _makeSession({required String request_token}) async {
    final formData = FormData.fromMap({
      "request_token": request_token,
    });
    try {
      Response response = await _client.post(
          "https://api.themoviedb.org/3/authentication/session/new?api_key=$_apiKey",
          data: formData,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      _validateResponse(response);
      final sessionId = response.data["session_id"];
      return sessionId;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  void _validateResponse(Response<dynamic> response) {
    if (response.statusCode == 401) {
      final status = response.data["status_code"];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.Auth);
      } else if (code == 3) {
        throw ApiClientException(ApiClientExceptionType.SessionExpired);
      } else {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }
  }

  Future<int> getAccountInfo(String sessionId) async {
    final uri = _makeUri("/account", <String, dynamic>{
      "api_key": _apiKey,
      "session_id": sessionId,
    });
    try {
      Response response = await _client.getUri(uri);
      _validateResponse(response);
      final movies = response.data["id"] as int;
      return movies;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<dynamic> markAsFavorite(
      {required int accountId,
      required String sessionId,
      required MediaType mediaType,
      required int mediaId,
      required bool isFavorite}) async {
    final formData = FormData.fromMap({
      "media_type": mediaType.asString(),
      "media_id": mediaId,
      "favorite": isFavorite,
    });
    try {
      Response response = await _client.post(
          "https://api.themoviedb.org/3/account/$accountId/favorite?api_key=$_apiKey&session_id=$sessionId",
          data: formData,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      _validateResponse(response);
      final data = response.data;
      return data;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<PopularMovieResponse> getPopularMovie(int page, String locale) async {
    final uri = _makeUri("/movie/popular?", <String, dynamic>{
      "api_key": _apiKey,
      "language": locale,
      "page": page.toString()
    });
    try {
      Response response = await _client.getUri(uri);
      _validateResponse(response);
      final movies =
          PopularMovieResponse.fromJson(response.data as Map<String, dynamic>);
      return movies;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<PopularMovieResponse> getSearchMovie(
      int page, String locale, String query) async {
    final uri = _makeUri("/search/movie", <String, dynamic>{
      "api_key": _apiKey,
      "language": locale,
      "page": page.toString(),
      "query": query,
      "include_adult": true.toString(),
    });
    try {
      Response response = await _client.getUri(uri);
      _validateResponse(response);
      final movies =
          PopularMovieResponse.fromJson(response.data as Map<String, dynamic>);
      return movies;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<MovieDetails> getMovieDetails(int movieId, String locale) async {
    final uri = _makeUri("/movie/$movieId", <String, dynamic>{
      "append_to_response": "credits,videos",
      "api_key": _apiKey,
      "language": locale,
    });
    try {
      Response response = await _client.getUri(uri);
      _validateResponse(response);
      final movies =
          MovieDetails.fromJson(response.data as Map<String, dynamic>);
      return movies;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<bool> isFavorite(int movieId, String sessionId) async {
    final uri = _makeUri("/movie/$movieId/account_states", <String, dynamic>{
      "api_key": _apiKey,
      "session_id": sessionId,
    });
    try {
      Response response = await _client.getUri(uri);
      _validateResponse(response);
      if (response.statusCode == 201) {
        return false;
      }
      final movies = response.data['favorite'] as bool;
      return movies;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }
}
