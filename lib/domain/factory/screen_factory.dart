import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/auth/auth_model.dart';
import 'package:flutter_application_1/widget/auth/auth_widget.dart';
import 'package:flutter_application_1/widget/loader/loader_view_model.dart';
import 'package:flutter_application_1/widget/loader/loader_widget.dart';
import 'package:flutter_application_1/widget/mainscreen/main_screen_widget.dart';
import 'package:flutter_application_1/widget/movieList/movie_list_model.dart';
import 'package:flutter_application_1/widget/movieList/movie_list_widget.dart';
import 'package:flutter_application_1/widget/movieTrailer/movie_trailer.dart';
import 'package:flutter_application_1/widget/movie_datails/movie_datails_widget.dart';
import 'package:flutter_application_1/widget/movie_datails/movie_details_model.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      // ignore: sort_child_properties_last
      child: const LoaderWidget(),
      lazy: false,
    );
  }

  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    return const MainScreenWidget();
  }

  Widget makeMovieDetails(arguments) {
    if (arguments is int) {
      return ChangeNotifierProvider<MovieDetailsModel>(
          create: (context) => MovieDetailsModel(arguments),
          child: MovieDatailsWidget(movieId: arguments));
    } else {
      return const MovieDatailsWidget(movieId: 0);
    }
  }

  Widget makeMovieTrailer(arguments) {
    if (arguments is String) {
      return MovieTrailer(youtubeKey: arguments);
    } else {
      return const MovieTrailer(youtubeKey: '');
    }
  }

  Widget makeMovieList() {
    return ChangeNotifierProvider<MovieListViewModel>(
      create: (_) => MovieListViewModel(),
      child: const MovieListWidget(),
    );
  }
}
