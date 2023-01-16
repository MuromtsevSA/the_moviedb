import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/movie_datails/movie_datails_info_widget.dart';
import 'package:flutter_application_1/widget/movie_datails/movie_datails_screencast_widget.dart';
import 'package:flutter_application_1/widget/movie_datails/movie_details_model.dart';
import 'package:provider/provider.dart';

class MovieDatailsWidget extends StatelessWidget {
  final int movieId;
  const MovieDatailsWidget({super.key, required this.movieId});
  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    return FutureBuilder(
      future: model.setupLocale(context),
      builder: (context, data) => data.connectionState == ConnectionState.done
          ? Scaffold(
              appBar: AppBar(
                title: const _TitleWidget(),
              ),
              body: const ColoredBox(
                color: Color.fromRGBO(24, 23, 27, 1.0),
                child: _BodyWidget(),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final title = context.select((MovieDetailsModel model) =>
        model.movieDetails?.details.title ?? "Загрузка...");
    return Text(title);
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        MovieDatailsInfoWidget(),
        SizedBox(height: 30),
        MovieDatailsScreenCastWidget(),
      ],
    );
  }
}
