import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/factory/screen_factory.dart';

abstract class MainNavigationRoutName {
  static const loaderWidget = '/';
  static const auth = "/auth";
  static const mainscreen = '/main_screen';
  static const movieDatails = '/main_screen/movie_datails';
  static const movieTrailer = '/main_screen/movie_datails/movie_trailer';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRoutName.loaderWidget: ((_) => _screenFactory.makeLoader()),
    MainNavigationRoutName.auth: ((_) => _screenFactory.makeAuth()),
    MainNavigationRoutName.mainscreen: ((_) => _screenFactory.makeMainScreen()),
    MainNavigationRoutName.movieDatails: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      return _screenFactory.makeMovieDetails(arguments);
    },
    MainNavigationRoutName.movieTrailer: ((context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      return _screenFactory.makeMovieTrailer(arguments);
    })
  };

  static void resetNavigation(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainNavigationRoutName.loaderWidget,
      (route) => false,
    );
  }
}
