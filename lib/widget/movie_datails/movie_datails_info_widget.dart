import 'package:flutter/material.dart';
import 'package:flutter_application_1/resources/resources.dart';

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
        const _SummaryWidget(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        const SizedBox(height: 30),
        const _PeopleWidget(),
      ],
    );
  }

  Text _DescriptionWidget() {
    return const Text(
      "data",
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
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
    return Stack(
      children: const [
        Image(image: AssetImage(Images.mortal)),
        Positioned(
          top: 20,
          left: 20,
          bottom: 20,
          child: Image(image: AssetImage(Images.mortal)),
        )
      ],
    );
  }
}

class _MovieNameWdget extends StatelessWidget {
  const _MovieNameWdget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(children: [
        TextSpan(
          text: "mortal combat ",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        TextSpan(
          text: " (2020)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        )
      ]),
      maxLines: 3,
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
        child: Text(
          "16+ 5.05.2020 (US) 1h49m Fanatastic",
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
      ),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final nameStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white);
    final jobStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white);
    return Column(children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Stefano", style: nameStyle),
              Text("Director", style: jobStyle),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Stefano", style: nameStyle),
              Text("Director", style: jobStyle),
            ],
          )
        ],
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Stefano", style: nameStyle),
              Text("Director", style: jobStyle),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Stefano", style: nameStyle),
              Text("Director", style: jobStyle),
            ],
          ),
        ],
      ),
    ]);
  }
}
