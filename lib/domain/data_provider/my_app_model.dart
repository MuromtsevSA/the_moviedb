import 'package:flutter/material.dart';
import 'package:flutter_application_1/Navigation/navigation.dart';
import 'package:flutter_application_1/domain/data_provider/session_data_providers.dart';

class MyAppModel {
  final _sessionDataProvider = SessionDataProvider();
  var _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    _isAuth = sessionId != null;
  }

  Future<void> ressetSession(BuildContext context) async {
    await _sessionDataProvider.setSessionId(null);
    await _sessionDataProvider.setAccountId(null);
    await Navigator.of(context).pushNamedAndRemoveUntil(
      MainNavigationRoutName.auth,
      (route) => false,
    );
  }
}
