import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_application_1/configuration/configuration.dart';
import 'package:flutter_application_1/domain/api_client/api_client_exception.dart';
import 'package:flutter_application_1/domain/api_client/api_client_validate_response.dart';

class AuthApiClient {
  final Dio _client = Dio(BaseOptions(
    baseUrl: Configuration.host,
    headers: {
      'Content-Type': 'application/json',
      'X-RapidAPI-Host': 'https://api.themoviedb.org/3',
      'X-RapidAPI-Key': '....',
      'useQueryString': true
    },
  ));

  Future<String> auth(
      {required String username, required String password}) async {
    final token = await _makeToken();
    final validateToken = await _validateUser(
        username: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validateToken);
    return sessionId;
  }

  Future<String> _makeToken() async {
    try {
      Response response = await _client.get("/authentication/token/new",
          queryParameters: <String, dynamic>{"api_key": Configuration.apiKey});
      ValidateResponse.validateResponse(response);
      final token = response.data["request_token"];
      return token;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<String> _validateUser(
      {required String username,
      required String password,
      required String requestToken}) async {
    final formData = FormData.fromMap({
      "username": username,
      "password": password,
      "request_token": requestToken,
    });
    try {
      Response response = await _client.post(
        "/authentication/token/validate_with_login?api_key=${Configuration.apiKey}",
        data: formData,
      );
      ValidateResponse.validateResponse(response);
      final token = response.data["request_token"];
      return token;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<String> _makeSession({required String requestToken}) async {
    final formData = FormData.fromMap({
      "request_token": requestToken,
    });
    try {
      Response response = await _client.post(
        "/authentication/session/new?api_key=${Configuration.apiKey}",
        data: formData,
      );
      ValidateResponse.validateResponse(response);
      final sessionId = response.data["session_id"];
      return sessionId;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }
}
