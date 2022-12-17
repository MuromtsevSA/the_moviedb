import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/auth/auth_model.dart';
import 'package:flutter_application_1/widget/movieList/movie_list_widget.dart';
import 'package:provider/provider.dart';

import '../../domain/data_provider/session_data_providers.dart';
import '../movieList/movie_list_model.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  MovieListModel modelMovies = MovieListModel();

  void onSelectedTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void didChangeDependencies() {
    // modelMovies.loadMovies();
    // modelMovies.setupLocale(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("mainscreen"), actions: [
        IconButton(
          onPressed: () => SessionDataProvider().setSessionId(null),
          icon: const Icon(Icons.search),
        )
      ]),
      body: IndexedStack(
        index: _selectedTab,
        children: const [
          Text(
            'Index 0: Новости',
          ),
          MovieListWidget(),
          Text(
            'Index 1: Фильмы',
          ),
          Text(
            'Index 2: Сериалы',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Новости"),
          BottomNavigationBarItem(
              icon: Icon(Icons.movie_filter), label: "Фильмы"),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: "Сериалы"),
        ],
        onTap: onSelectedTab,
      ),
    );
  }
}
