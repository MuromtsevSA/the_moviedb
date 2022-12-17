import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/domain/entity/popular_movie_response.dart';

enum ApiClientExceptionType { Network, Auth, Other }

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
    // _client.options.baseUrl = _host;
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
          "/authentication/token/validate_with_login?api_key=$_apiKey",
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
      Response response =
          await _client.post("/authentication/session/new?api_key=$_apiKey",
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
      } else {
        throw ApiClientException(ApiClientExceptionType.Other);
      }
    }
  }

  Future<PopularMovieResponse> getPopularMovie(int page, String locale) async {
    final uri = _makeUri("/movie/popular?", <String, dynamic>{
      "api_key": _apiKey,
      "language": locale,
      "page": page.toString()
    });
    // final uri =
    //     "https://api.themoviedb.org/3/movie/popular?api_key=ed22f6a0b5fe2885031bb0c9237efa36&language=$locale&page=$page";
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
}
