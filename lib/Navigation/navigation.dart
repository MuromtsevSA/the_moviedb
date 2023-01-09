import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/data_provider/my_app_model.dart';
import 'package:flutter_application_1/widget/movie_datails/movie_details_model.dart';
import 'package:provider/provider.dart';

import '../widget/auth/auth_widget.dart';
import '../widget/mainscreen/main_screen_widget.dart';
import '../widget/movie_datails/movie_datails_widget.dart';
import 'package:flutter_application_1/widget/movieTrailer/movie_trailer.dart';

abstract class MainNavigationRoutName {
  static const auth = "auth";
  static const mainscreen = '/';
  static const movieDatails = '/movie_datails';
  static const movieTrailer = '/movie_datails/movie_trailer';
}

class MainNavigation {
  String initialRout(isAuth) =>
      isAuth ? MainNavigationRoutName.mainscreen : MainNavigationRoutName.auth;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRoutName.auth: ((context) => const AuthWidget()),
    MainNavigationRoutName.mainscreen: ((context) => const MainScreenWidget()),
    MainNavigationRoutName.movieDatails: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is int) {
        return ChangeNotifierProvider<MovieDetailsModel>(
            create: (context) => MovieDetailsModel(arguments),
            child: MovieDatailsWidget(movieId: arguments));
      } else {
        return const MovieDatailsWidget(movieId: 0);
      }
    },
    MainNavigationRoutName.movieTrailer: ((context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is String) {
        return MovieTrailer(youtubeKey: arguments);
      } else {
        return const MovieTrailer(youtubeKey: '');
      }
    })
  };
}
