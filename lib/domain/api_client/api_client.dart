import 'dart:io';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _client = Dio();
  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = 'ed22f6a0b5fe2885031bb0c9237efa36';

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
    Response response = await _client.getUri(url);
    if (response.statusCode == 200) {
      final token = response.data["request_token"];
      return token;
    } else {
      return response.statusMessage.toString();
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
    Response response = await _client.post(
        "$_host/authentication/token/validate_with_login?api_key=$_apiKey",
        data: formData,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }));
    if (response.statusCode == 200) {
      final token = response.data["request_token"];
      return token;
    } else {
      return response.statusMessage.toString();
    }
  }

  Future<String> _makeSession({required String request_token}) async {
    final formData = FormData.fromMap({
      "request_token": request_token,
    });
    Response response =
        await _client.post("$_host/authentication/session/new?api_key=$_apiKey",
            data: formData,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }));
    if (response.statusCode == 200) {
      final sessionId = response.data["session_id"];
      return sessionId;
    } else {
      return response.statusMessage.toString();
    }
  }
}
