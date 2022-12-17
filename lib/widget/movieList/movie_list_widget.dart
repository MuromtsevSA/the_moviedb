import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/api_client/api_client.dart';
import 'package:flutter_application_1/widget/auth/auth_model.dart';
import 'package:flutter_application_1/widget/movieList/movie_list_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MovieListWidget extends StatelessWidget {
  const MovieListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieListModel>();
    return FutureBuilder(
        future: provider.setupLocale(context),
        builder: (context, data) {
          // if (data.connectionState != ConnectionState.active) {
          //   return const Center(child: CircularProgressIndicator());
          // }
          return Stack(
            children: [
              ListView.builder(
                itemCount: provider.movies.length,
                padding: const EdgeInsets.only(top: 70),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemExtent: 163,
                itemBuilder: (BuildContext context, int index) {
                  provider.showMovieAtIndex(index);
                  final movie = provider.movies[index];
                  final posterPath = movie.posterPath;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.black.withOpacity(0.2)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: (() => provider.onMovieTap(context, index)),
                          child: Row(
                            children: [
                              posterPath != null
                                  ? Image.network(ApiClient.imgUrl(posterPath),
                                      width: 95)
                                  : const SizedBox.shrink(),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      movie.title.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      provider
                                          .stringFromDate(movie.releaseDate),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      movie.overview,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Поиск",
                      filled: true,
                      fillColor: Colors.white.withAlpha(235),
                      border: const OutlineInputBorder()),
                ),
              ),
            ],
          );
        });
  }
}
