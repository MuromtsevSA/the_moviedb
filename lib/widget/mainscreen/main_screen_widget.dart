import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/data_provider/session_data_providers.dart';
import 'package:flutter_application_1/domain/factory/screen_factory.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  static final _screenFactory = ScreenFactory();
  int _selectedTab = 0;

  void onSelectedTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("mainscreen"), actions: [
        IconButton(
          onPressed: () => {},
          icon: const Icon(Icons.search),
        )
      ]),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          const Text(
            'Index 0: Новости',
          ),
          _screenFactory.makeMovieList(),
          const Text(
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
