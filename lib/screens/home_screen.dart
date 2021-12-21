import 'package:flutter/material.dart';
import 'package:peliculas/providers/movie_provider.dart';
import 'package:peliculas/search/movie_search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas'),
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: MovieSearchDelegate(),
            ),
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.white,
              size: 30.0,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(
              movies: movieProvider.movie,
            ),
            MovieSlider(
                moviesPopular: movieProvider.moviePopular,
                onNextPage: () => movieProvider.getOnDisplayMoviePopular(),
                msnEmptyMovies: 'No hay peliculas populares para mostrar'),
            const SizedBox(
              height: 15,
            ),
            MovieSlider(
                title: 'Peliculas top',
                moviesPopular: movieProvider.topMovie,
                onNextPage: () => movieProvider.getOnDisplayTopMovie(),
                msnEmptyMovies: 'No hay pelicuals top para mostrar'),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
