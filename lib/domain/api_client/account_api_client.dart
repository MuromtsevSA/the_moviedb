import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_application_1/configuration/configuration.dart';
import 'package:flutter_application_1/domain/api_client/api_client_exception.dart';
import 'package:flutter_application_1/domain/api_client/api_client_validate_response.dart';

enum MediaType { movie, tv }

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.movie:
        return "movie";
      case MediaType.tv:
        return "tv";
    }
  }
}

class AccountApiClient {
  final Dio _client = Dio(BaseOptions(
    baseUrl: Configuration.host,
    headers: {
      'Content-Type': 'application/json',
      'X-RapidAPI-Host': 'https://api.themoviedb.org/3',
      'X-RapidAPI-Key': '....',
      'useQueryString': true
    },
  ));

  Future<int> getAccountInfo(String sessionId) async {
    try {
      Response response =
          await _client.get("/account", queryParameters: <String, dynamic>{
        "api_key": Configuration.apiKey,
        "session_id": sessionId,
      });
      ValidateResponse.validateResponse(response);
      final movies = response.data["id"] as int;
      return movies;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
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
        "/account/$accountId/favorite?api_key=${Configuration.apiKey}&session_id=$sessionId",
        data: formData,
      );
      ValidateResponse.validateResponse(response);
      final data = response.data;
      return data;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }
}
