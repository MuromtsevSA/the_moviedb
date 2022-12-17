import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import '../../Navigation/navigation.dart';
import '../../domain/api_client/api_client.dart';
import '../../domain/data_provider/session_data_providers.dart';
import '../../domain/entity/movie.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  final TextEditingController _authController = TextEditingController();
  TextEditingController get authController => _authController;

  final TextEditingController _passController = TextEditingController();
  TextEditingController get passController => _passController;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuth = true;
  bool get canStartAuth => !_isAuth;
  bool get isAuthProgress => _isAuth;


  Future<void> auth(BuildContext context) async {
    if (_authController.text.isEmpty || _passController.text.isEmpty) {
      _errorMessage = "Заполните логин и пароль";
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuth = true;
    notifyListeners();
    String? sessionId;
    try {
      sessionId = await _apiClient.auth(
          username: _authController.text, password: _passController.text);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.Network:
          _errorMessage =
              "Сервер не доступен.Проверьте подключение к интернету";
          break;
        case ApiClientExceptionType.Auth:
          _errorMessage =
              "Ошибка авторизация.Проверьте пральность введенных данных";
          break;
        case ApiClientExceptionType.Other:
          _errorMessage = "Неизвестная ошибка";
          break;
      }
    } catch (e) {
      _errorMessage = "Призошла ошибка.Попробуйте еще раз";
    }
    _isAuth = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }
    if (sessionId == null) {
      _errorMessage = "Неизвестная ошибка";
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sessionId);
    unawaited(Navigator.of(context)
        .pushReplacementNamed(MainNavigationRoutName.mainscreen));
  }
}
