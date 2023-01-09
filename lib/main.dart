import 'package:flutter/material.dart';
import 'package:flutter_application_1/Navigation/navigation.dart';
import 'package:flutter_application_1/widget/auth/auth_model.dart';
import 'package:flutter_application_1/widget/movieList/movie_list_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'domain/data_provider/my_app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
  await model.checkAuth();
  final widget =
      Provider(create: (context) => MyAppModel(), child: const MyApp());
  runApp(widget);
}

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final model = context.read<MyAppModel>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel()),
        ChangeNotifierProvider(create: (context) => MovieListModel()),
      ],
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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', 'RU'), // English, no country code
          Locale('en', ''), // Spanish, no country code
        ],
        routes: mainNavigation.routes,
        initialRoute: mainNavigation.initialRout(model.isAuth),
      ),
    );
  }
}
