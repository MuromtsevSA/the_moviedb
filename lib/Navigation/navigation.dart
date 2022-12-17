import 'package:flutter/material.dart';

import '../widget/auth/auth_widget.dart';
import '../widget/mainscreen/main_screen_widget.dart';
import '../widget/movie_datails/movie_datails_widget.dart';

abstract class MainNavigationRoutName {
  static const auth = "auth";
  static const mainscreen = '/';
  static const movieDatails = '/movie_datails';
}

class MainNavigation {
  String initialRout(bool isAuth) =>
      isAuth ? MainNavigationRoutName.mainscreen : MainNavigationRoutName.auth;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRoutName.auth: ((context) => const AuthWidget()),
    MainNavigationRoutName.mainscreen: ((context) => const MainScreenWidget()),
    MainNavigationRoutName.movieDatails: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is int) {
        return MovieDatailsWidget(movieId: arguments);
      } else {
        return const MovieDatailsWidget(movieId: 0);
      }
    }
  };
}
