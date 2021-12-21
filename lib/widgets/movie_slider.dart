import 'package:flutter/material.dart';
import 'package:peliculas/models/model.dart';

class MovieSlider extends StatefulWidget {
  final List<Movies> moviesPopular;
  final String? title;
  final Function onNextPage;
  final int? idMovie;
  final String msnEmptyMovies;

  const MovieSlider({
    Key? key,
    required this.moviesPopular,
    this.title,
    required this.onNextPage,
    this.idMovie,
    required this.msnEmptyMovies,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final ScrollPosition position = scrollController.position;

      if (position.pixels >= position.maxScrollExtent - 500) {
        if (widget.idMovie != null) {
          widget.onNextPage(widget.idMovie);
        } else {
          widget.onNextPage();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _empty(),
          _listPopulares(),
        ],
      ),
    );
  }

  Expanded _listPopulares() {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.moviesPopular.length,
        itemBuilder: (_, int index) {
          final moviePopular = widget.moviesPopular[index];

          return _Populares(
            moviePopular: moviePopular,
            heroId: 'slider ${widget.moviesPopular[index].id} ${widget.title}',
          );
        },
      ),
    );
  }

  Padding _title() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        right: 20,
        left: 20,
        bottom: 10,
      ),
      child: Text(
        widget.title ?? 'Películas populares',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding _empty() => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Text(
          widget.moviesPopular.isEmpty ? widget.msnEmptyMovies : '',
          style: const TextStyle(fontSize: 20, color: Colors.red),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      );
}

class _Populares extends StatelessWidget {
  final Movies moviePopular;
  final String heroId;

  const _Populares({
    Key? key,
    required this.moviePopular,
    required this.heroId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    moviePopular.heroId = heroId;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 130,
      height: 230,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'details',
              arguments: moviePopular,
            ),
            child: Hero(
              tag: moviePopular.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  height: 190,
                  width: 130,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(moviePopular.fullPosterImg),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Flexible(
            child: Text(
              moviePopular.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
