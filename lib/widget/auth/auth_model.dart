import 'package:flutter/material.dart';
import 'package:flutter_application_1/Navigation/navigation.dart';
import 'package:flutter_application_1/domain/api_client/api_client_exception.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = AuthService();

  final TextEditingController _authController = TextEditingController();
  TextEditingController get authController => _authController;

  final TextEditingController _passController = TextEditingController();
  TextEditingController get passController => _passController;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuth = true;
  bool get canStartAuth => !_isAuth;
  bool get isAuthProgress => _isAuth;

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  Future<String?> _login(String login, String password) async {
    try {
      await _authService.login(_authController.text, _passController.text);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          return "Сервер не доступен.Проверьте подключение к интернету";
        case ApiClientExceptionType.auth:
          return "Ошибка авторизация.Проверьте пральность введенных данных";
        case ApiClientExceptionType.sessionExpired:
        case ApiClientExceptionType.other:
          return "Неизвестная ошибка";
      }
    } catch (e) {
      return "Призошла ошибка.Попробуйте еще раз";
    }
    return null;
  }

  Future<void> auth(BuildContext context) async {
    if (!_isValid(_authController.text, _passController.text)) {
      _updateState("Заполните логин и пароль", false);
      return;
    }

    _updateState(null, true);

    _errorMessage = await _login(_authController.text, _passController.text);
    if (_errorMessage == null) {
      // ignore: use_build_context_synchronously
      MainNavigation.resetNavigation(context);
    } else {
      _updateState(_errorMessage, false);
    }
  }

  void _updateState(String? errorMessage, bool isAuthProgress) {
    if (_errorMessage == errorMessage && _isAuth == isAuthProgress) {
      return;
    }
    _errorMessage = errorMessage;
    _isAuth = isAuthProgress;
    notifyListeners();
  }
}
