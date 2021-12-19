import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:peliculas/providers/movie_provider.dart';
import 'package:provider/provider.dart';

import 'screens/screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieProvider(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': (_) => const HomeScreen(),
          'details': (_) => const DetailsScreen()
        },
        theme: ThemeData.dark());
  }
}
