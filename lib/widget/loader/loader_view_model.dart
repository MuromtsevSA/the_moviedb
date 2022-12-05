import 'package:flutter/cupertino.dart';

class LoaderViewModel {
  BuildContext context;
  // final _sessionDataProvider = SessionDataProvider();

  LoaderViewModel(this.context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    await checkAuth();
  }

  Future<void> checkAuth() async {
    // final sessionId = await _sessionDataProvider.getSessionId();
    // final _isAuth = sessionId != null;
  }
}
