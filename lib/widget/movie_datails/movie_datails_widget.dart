import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/movie_datails/movie_datails_info_widget.dart';
import 'package:flutter_application_1/widget/movie_datails/movie_datails_screencast_widget.dart';

class MovieDatailsWidget extends StatefulWidget {
  final int movieId;
  const MovieDatailsWidget({super.key, required this.movieId});

  @override
  State<MovieDatailsWidget> createState() => _MovieDatailsWidgetState();
}

class _MovieDatailsWidgetState extends State<MovieDatailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Data"),
      ),
      body: ColoredBox(
        color: const Color.fromRGBO(24, 23, 27, 1.0),
        child: ListView(
          children: const [
            MovieDatailsInfoWidget(),
            SizedBox(
              height: 30,
            ),
            MovieDatailsScreenCastWidget(),
          ],
        ),
      ),
    );
  }
}
