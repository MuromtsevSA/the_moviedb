import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/api_client/api_client.dart';
import 'package:flutter_application_1/domain/entity/movie_details_credits.dart';
import 'package:flutter_application_1/Navigation/navigation.dart';
import 'package:flutter_application_1/widget/movie_datails/movie_details_model.dart';
import 'package:provider/provider.dart';

class MovieDatailsInfoWidget extends StatelessWidget {
  const MovieDatailsInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TopPoster(),
        const Padding(
          padding: EdgeInsets.all(25.0),
          child: _MovieNameWdget(),
        ),
        const _VideoPlayWidget(),
        const _SummaryWidget(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: _OverviewWidget(),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _PeopleWidget(),
        ),
      ],
    );
  }

  Text _OverviewWidget() {
    return const Text(
      "Overview",
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
    );
  }
}

class _TopPoster extends StatelessWidget {
  const _TopPoster({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    final backdropPath = model.movieDetails?.details.backdropPath;
    final posterPath = model.movieDetails?.details.posterPath;
    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          backdropPath != null
              ? Image.network(ApiClient.imgUrl(backdropPath.toString()))
              : const SizedBox.shrink(),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: posterPath != null
                ? Image.network(ApiClient.imgUrl(posterPath.toString()))
                : const SizedBox.shrink(),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () => model.toggleFavorite(context),
              icon: Icon(model.isFavorite == true
                  ? Icons.favorite
                  : Icons.favorite_border_outlined),
            ),
          )
        ],
      ),
    );
  }
}

class _MovieNameWdget extends StatelessWidget {
  const _MovieNameWdget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    var year = model.movieDetails?.details.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: model.movieDetails?.details.title ?? ' ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          TextSpan(
            text: year,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          )
        ]),
        maxLines: 3,
      ),
    );
  }
}

class _VideoPlayWidget extends StatelessWidget {
  const _VideoPlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    final videos = model.movieDetails?.details.videos.results
        .where((video) => video.type == "Trailer" && video.site == "YouTube");
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;
    return ColoredBox(
      color: const Color.fromARGB(255, 32, 31, 37),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            trailerKey != null
                ? TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                        MainNavigationRoutName.movieTrailer,
                        arguments: trailerKey),
                    child: Row(
                      children: const [
                        Icon(Icons.play_arrow),
                        Text("Play trailer", style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    if (model == null) return const SizedBox.shrink();
    var texts = <String>[];
    final releaseDate = model.movieDetails?.details.releaseDate;
    if (releaseDate != null) {
      texts.add(model.stringFromDate(releaseDate));
    }
    final country = model.movieDetails?.details.productionCountries;
    if (country != null && country.isNotEmpty) {
      texts.add('(${country.first.iso})');
    }
    final runtime = model.movieDetails?.details.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');

    final genres = model.movieDetails?.details.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genre in genres) {
        genresNames.add(genre.name);
      }
      texts.add(genresNames.join(', '));
    }
    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          texts.join(' '),
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    var employee = model.movieDetails?.details.credits.crew;
    if (employee == null || employee.isEmpty) return const SizedBox.shrink();
    employee = employee.length > 4 ? employee.sublist(0, 4) : employee;
    var crewChank = <List<Employee>>[];
    for (var i = 0; i < employee.length; i += 2) {
      crewChank.add(employee.sublist(
          i, i + 2 > employee.length ? employee.length : i + 2));
    }
    return Column(
        children: crewChank
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _PeopleWidgetRow(employes: e),
                ))
            .toList());
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    return Text(
      model.movieDetails?.details.overview ?? '',
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
    );
  }
}

class _PeopleWidgetRow extends StatelessWidget {
  final List<Employee> employes;
  const _PeopleWidgetRow({super.key, required this.employes});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: employes
          .map(
            (e) => _PeopleWidgetRowItem(employee: e),
          )
          .toList(),
    );
  }
}

class _PeopleWidgetRowItem extends StatelessWidget {
  final Employee employee;
  const _PeopleWidgetRowItem({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
    const jobStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.name, style: nameStyle),
          Text(employee.job, style: jobStyle),
        ],
      ),
    );
  }
}
