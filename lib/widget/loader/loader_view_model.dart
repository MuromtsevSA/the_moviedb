import 'package:flutter/material.dart';
import 'package:flutter_application_1/Navigation/navigation.dart';
import 'package:flutter_application_1/domain/data_provider/session_data_providers.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class LoaderViewModel {
  final BuildContext context;
  final _authService = AuthService();

  LoaderViewModel(this.context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    await checkAuth();
  }

  Future<void> checkAuth() async {
    final _isAuth = await _authService.isAuth();
    if (_isAuth) {
      await Navigator.of(context)
          .pushReplacementNamed(MainNavigationRoutName.mainscreen);
    } else {
      await Navigator.of(context)
          .pushReplacementNamed(MainNavigationRoutName.auth);
    }
  }
}
