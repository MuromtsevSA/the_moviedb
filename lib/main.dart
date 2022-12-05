import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/auth/auth_model.dart';
import 'package:flutter_application_1/widget/auth/auth_widget.dart';
import 'package:flutter_application_1/widget/mainscreen/main_screen_widget.dart';
import 'package:flutter_application_1/widget/movie_datails/movie_datails_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme:
              const AppBarTheme(backgroundColor: Color.fromRGBO(3, 37, 65, 1)),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(3, 37, 65, 1),
            selectedItemColor: Colors.yellow,
            unselectedItemColor: Colors.white,
          ),
        ),
        routes: {
          "/auth": ((context) => const AuthWidget()),
          "/main_screen": ((context) => const MainScreenWidget()),
          "/main_screen/movie_datails": (context) {
            final arguments = ModalRoute.of(context)?.settings.arguments;
            if (arguments is int) {
              return MovieDatailsWidget(movieId: arguments);
            } else {
              return const MovieDatailsWidget(movieId: 0);
            }
          },
        },
        initialRoute: "/auth",
      ),
    );
  }
}
