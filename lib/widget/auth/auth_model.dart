import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/api_client/api_client.dart';
import '../../domain/data_provider/session_data_providers.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = new ApiClient();
  final _sessionDataProvider = new SessionDataProvider();

  final TextEditingController _authController = TextEditingController();
  TextEditingController get authController => _authController;

  final TextEditingController _resetPassController = TextEditingController();
  TextEditingController get resetPassController => _resetPassController;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuth = false;
  bool get canStartAuth => !_isAuth;

  Future<void> auth(BuildContext context) async {
    if (_authController.text.isEmpty || _resetPassController.text.isEmpty) {
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
          username: _authController.text, password: _resetPassController.text);
    } catch (e) {
      _errorMessage = e.toString();
    }
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
    unawaited(Navigator.of(context).pushNamed('/main_screen'));
  }
}
