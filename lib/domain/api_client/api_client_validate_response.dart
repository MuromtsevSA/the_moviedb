import 'package:dio/dio.dart';
import 'package:flutter_application_1/domain/api_client/api_client_exception.dart';

class ValidateResponse {
  static void validateResponse(Response<dynamic> response) {
    if (response.statusCode == 401) {
      final status = response.data["status_code"];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.auth);
      } else if (code == 3) {
        throw ApiClientException(ApiClientExceptionType.sessionExpired);
      } else {
        throw ApiClientException(ApiClientExceptionType.other);
      }
    }
  }
}
