import 'package:flutter/material.dart';
import 'package:peliculas/models/movie_model.dart';
import 'package:peliculas/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar peliculas';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('BuildResult');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _empty();
    }

    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    movieProvider.getSuggestionsByQuery(query);
    return StreamBuilder(
      stream: movieProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movies>> snapshot) {
        if (!snapshot.hasData) return _empty();
        final List<Movies> data = snapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, int index) => _MovieItem(
            movie: data[index],
          ),
        );
      },
    );
  }

  Center _empty() {
    return const Center(
      child: Icon(
        Icons.movie_creation_outlined,
        size: 150,
        color: Colors.white38,
      ),
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movies movie;

  const _MovieItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = '${movie.id} ${movie.title}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        movie.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        movie.originalTitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => Navigator.pushNamed(
        context,
        'details',
        arguments: movie,
      ),
    );
  }
}
