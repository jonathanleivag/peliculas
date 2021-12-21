import 'package:flutter/material.dart';
import 'package:peliculas/models/model.dart';
import 'package:peliculas/providers/movie_provider.dart';
import 'package:peliculas/widgets/loading.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Movies arg = ModalRoute.of(context)!.settings.arguments as Movies;
    final MovieProvider movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const _CustomAppBar(),
        SliverList(
          delegate: SliverChildListDelegate([
            const _PosterAndTitle(),
            const _Overview(),
            const SizedBox(
              height: 10,
            ),
            CastingCards(
              getData: movieProvider.getMovieCast(arg.id),
              title: 'Reparto',
            ),
            CastingCards(
              getData: movieProvider.getMovieCrew(arg.id),
              title: 'Equipo',
            ),
            FutureBuilder(
                future: MovieProvider().getSimilar(arg.id),
                builder: (context, AsyncSnapshot<List<Movies>> snapshot) {
                  if (!snapshot.hasData) return const Loading();
                  List<Movies> data = snapshot.data as List<Movies>;
                  return MovieSlider(
                    moviesPopular: data,
                    onNextPage: movieProvider.getSimilar,
                    title: 'Pelicualas similares',
                    idMovie: arg.id,
                    msnEmptyMovies: 'No hay pelicuals similares para mostrar',
                  );
                }),
            FutureBuilder(
                future: MovieProvider().getRecommendations(arg.id),
                builder: (context, AsyncSnapshot<List<Movies>> snapshot) {
                  if (!snapshot.hasData) return const Loading();
                  List<Movies> data = snapshot.data as List<Movies>;
                  return MovieSlider(
                    moviesPopular: data,
                    onNextPage: movieProvider.getRecommendations,
                    title: 'Pelicualas recomendadas',
                    idMovie: arg.id,
                    msnEmptyMovies:
                        'No hay pelicuals recomendadas para mostrar',
                  );
                })
          ]),
        )
      ],
    ));
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
        expandedHeight: 200,
        floating: false,
        pinned: true,
        flexibleSpace: _FlexibleSpaceBar());
  }
}

class _FlexibleSpaceBar extends StatelessWidget {
  const _FlexibleSpaceBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: _Title(),
        background: _Background());
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Movies arg = ModalRoute.of(context)!.settings.arguments as Movies;

    return Container(
      color: Colors.black38,
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: Text(
        arg.title,
        style: const TextStyle(
          fontSize: 25,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Movies arg = ModalRoute.of(context)!.settings.arguments as Movies;

    return FadeInImage(
      placeholder: const AssetImage('assets/loading.gif'),
      image: NetworkImage(
        arg.fullBackdropPath,
      ),
      fit: BoxFit.cover,
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  const _PosterAndTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Movies arg = ModalRoute.of(context)!.settings.arguments as Movies;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: arg.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(
                  arg.fullPosterImg,
                ),
                height: 150,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arg.title,
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  arg.originalTitle,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_outline,
                      size: 15,
                      color: Colors.grey,
                    ),
                    Text(
                      arg.voteAverage.toString(),
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Movies arg = ModalRoute.of(context)!.settings.arguments as Movies;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        arg.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
