import 'package:flutter/material.dart';
import 'package:flutter_application_1/resources/resources.dart';

class Movie {
  int? id;
  String imageName;
  String title;
  String time;
  String description;

  Movie(
      {required this.id,
      required this.imageName,
      required this.title,
      required this.time,
      required this.description});
}

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({super.key});

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  final _movies = [
    Movie(
        id: 1,
        imageName: Images.mortal,
        title: "Смертельная битва",
        time: "2021",
        description: "mortal comabat"),
    Movie(
        id: 2,
        imageName: Images.mortal,
        title: "Первому игроку приготовится",
        time: "2018",
        description: "Gamer")
  ];

  var filtersMovie = <Movie>[];

  void _movieTap(int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed("/main_screen/movie_datails", arguments: id);
  }

  void _searchMovie() {
    if (_searchController.text.isNotEmpty) {
      filtersMovie = _movies.where((Movie movie) {
        return movie.title
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    } else {
      filtersMovie = _movies;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    filtersMovie = _movies;
    _searchController.addListener(_searchMovie);
  }

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: filtersMovie.length,
          padding: const EdgeInsets.only(top: 70),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemExtent: 163,
          itemBuilder: (BuildContext context, int index) {
            final movie = filtersMovie[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                    onTap: (() => _movieTap(index)),
                    child: Row(
                      children: [
                        Image(image: AssetImage(movie.imageName)),
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
                                movie.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                movie.time,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                movie.description,
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
            controller: _searchController,
            decoration: InputDecoration(
                labelText: "Поиск",
                filled: true,
                fillColor: Colors.white.withAlpha(235),
                border: const OutlineInputBorder()),
          ),
        ),
      ],
    );
  }
}
